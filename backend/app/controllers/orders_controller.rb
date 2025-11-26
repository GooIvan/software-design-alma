class OrdersController < ApplicationController
  before_action :authenticate_user!  # ← esto redirige al login si no hay sesión

  def create
    if current_cart.cart_items.empty?
      redirect_back fallback_location: root_path, alert: "El carrito está vacío."
      return
    end

    order_items_attributes = current_cart.cart_items.map do |item|
      {
        product_id: item.product.id,
        quantity: item.quantity,
        size: item.size,
      }
    end

    @order = Order.new(
      user: current_user,
      status: :pending,
      order_items_attributes: order_items_attributes,
    )
    @order.send(:set_item_prices_and_total)

    if @order.save
      current_cart.cart_items.destroy_all
      redirect_to payment_order_path(@order), notice: "Orden creada. Procede al pago."
    else
      Rails.logger.error "[ORDER ERROR] No se pudo crear la orden: #{@order.errors.full_messages.join(", ")}"
      if @order.order_items.any? { |item| item.errors.any? }
        @order.order_items.each_with_index do |item, idx|
          if item.errors.any?
            Rails.logger.error "[ORDER ITEM ERROR] Item ##{idx + 1}: #{item.errors.full_messages.join(", ")}"
          end
        end
      end
      flash[:alert] = @order.errors.map(&:message).to_sentence
      redirect_back fallback_location: root_path
    end
  end

  def payment
    @order = Order.find(params[:id])

    unless @order.user == current_user && @order.pending?
      redirect_to root_path, alert: "No autorizado o la orden ya fue pagada."
    end
  end

  def pay_with_card
    Rails.logger.info "[PAYMENT] Iniciando flujo de pago para order_id=#{params[:id]}"

    @order = Order.find(params[:id])
    Rails.logger.info "[PAYMENT] Orden encontrada: id=#{@order.id}, status=#{@order.status}, user_id=#{@order.user_id}"

    unless @order.user == current_user && @order.pending?
      Rails.logger.warn "[PAYMENT] Acceso denegado: user_id=#{current_user.id} intentó pagar order_id=#{@order.id} con estado=#{@order.status}"
      redirect_to root_path, alert: "No autorizado o la orden ya fue pagada."
      return
    end

    if request.post?
      # Guardar temporalmente la información del descuento sin aplicarlo aún
      discount_code = nil
      discount_amount = 0
      
      if params[:discount_code_id].present?
        discount_code = DiscountCode.find_by(id: params[:discount_code_id])
        
        if discount_code
          # Validaciones detalladas para mejor logging
          if !discount_code.active?
            Rails.logger.warn "[PAYMENT] Código de descuento inactivo: #{discount_code.code}"
          elsif discount_code.expired?
            Rails.logger.warn "[PAYMENT] Código de descuento expirado: #{discount_code.code}"
          elsif discount_code.user.present? && discount_code.user != current_user
            Rails.logger.warn "[PAYMENT] Código de descuento exclusivo para otro usuario: #{discount_code.code}"
          elsif discount_code.max_uses && discount_code.discount_usages.count >= discount_code.max_uses
            Rails.logger.warn "[PAYMENT] Código de descuento ha alcanzado límite total de usos: #{discount_code.code} (#{discount_code.discount_usages.count}/#{discount_code.max_uses})"
          elsif discount_code.max_uses_per_user && discount_code.discount_usages.where(user: current_user).count >= discount_code.max_uses_per_user
            Rails.logger.warn "[PAYMENT] Usuario ya alcanzó límite de usos para el código: #{discount_code.code} (#{discount_code.discount_usages.where(user: current_user).count}/#{discount_code.max_uses_per_user})"
          elsif discount_code.usable_by?(current_user)
            discount_amount = discount_code.apply_to(@order.total)
            Rails.logger.info "[PAYMENT] Código de descuento válido: #{discount_code.code}, descuento potencial: #{discount_amount}"
          else
            Rails.logger.warn "[PAYMENT] Código de descuento no utilizable por razón desconocida: #{discount_code.code}"
          end
        else
          Rails.logger.warn "[PAYMENT] Código de descuento no encontrado con ID: #{params[:discount_code_id]}"
        end
        
        # Si no es utilizable, resetear variables
        if !discount_code&.usable_by?(current_user)
          discount_code = nil
          discount_amount = 0
        end
      end

      card_info = {
        number: params[:card_number],
        cvv: params[:cvv],
        expiration: params[:expiration],  # formato "YYYY/MM"
        name: params[:card_name],
        method: "VISA", # o "MASTERCARD", etc.
      }
      Rails.logger.info "[PAYMENT] Card info recibida (ocultando datos sensibles): ****#{card_info[:number].to_s[-4..-1]}, metodo=#{card_info[:method]}"

      # Crear el pago con PayU usando el total con descuento (si aplica)
      payment_total = @order.total - discount_amount
      
      # Temporalmente actualizar el total para el pago (sin guardar en BD aún)
      original_total = @order.total
      @order.total = payment_total
      
      response = PayuService.create_payment(@order, current_user, card_info)

      Rails.logger.info "[PAYMENT] Respuesta PayU: #{response.inspect}"

      if response[:code] == "SUCCESS" && response[:transaction_state] == "APPROVED"
        # Pago aprobado - AHORA sí aplicamos el descuento permanentemente
        if discount_code && discount_amount > 0
          # Validación final antes de aplicar descuento (protección contra concurrencia)
          discount_code.reload # Recargar para obtener datos frescos de la BD
          
          if discount_code.usable_by?(current_user)
            @order.update!(
              discount_code: discount_code,
              discount_amount: discount_amount,
              total: payment_total,
              status: :paid
            )
            
            # Crear registro de uso del descuento solo cuando el pago sea exitoso
            DiscountUsage.create!(
              discount_code: discount_code,
              user: current_user,
              order: @order,
              discount_amount: discount_amount
            )
            
            Rails.logger.info "[PAYMENT] Pago aprobado y descuento aplicado: código=#{discount_code.code}, descuento=#{discount_amount}, total_final=#{@order.total}"
          else
            # El código ya no es válido (posible uso concurrente)
            @order.update!(total: original_total, status: :paid)
            Rails.logger.warn "[PAYMENT] Pago aprobado pero código de descuento ya no es válido (posible uso concurrente): #{discount_code.code}. Pago procesado sin descuento."
          end
        else
          @order.update!(status: :paid)
          Rails.logger.info "[PAYMENT] Pago aprobado sin descuento para order_id=#{@order.id}"
        end
        
        flash[:notice] = "Pago aprobado"
      else
        # Pago fallido - restaurar el total original y NO aplicar descuento
        @order.update!(total: original_total, status: :cancelled)
        error = response[:message] || "Error desconocido"
        Rails.logger.error "[PAYMENT] Pago fallido para order_id=#{@order.id} - Motivo: #{error}. Código de descuento NO utilizado."
        flash[:alert] = "Pago fallido: #{error}"
      end

      redirect_to order_path(@order)
    end
  end

  def show
    @order = Order.find(params[:id])

    unless @order.user == current_user
      redirect_to root_path, alert: "No autorizado"
    end
  end
end
