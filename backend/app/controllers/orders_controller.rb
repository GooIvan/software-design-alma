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

    if @order.save
      current_cart.cart_items.destroy_all
      redirect_to payment_order_path(@order), notice: "Orden creada. Procede al pago."
    else
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
      # Aplicar código de descuento si se proporcionó
      if params[:discount_code_id].present?
        discount_code = DiscountCode.find_by(id: params[:discount_code_id])
        
        if discount_code && discount_code.usable_by?(current_user)
          original_total = @order.total
          discount_amount = discount_code.apply_to(original_total)
          
          @order.update!(
            discount_code: discount_code,
            total: original_total - discount_amount
          )
          
          # Crear registro de uso del descuento
          DiscountUsage.create!(
            discount_code: discount_code,
            user: current_user,
            order: @order,
            discount_amount: discount_amount
          )
          
          Rails.logger.info "[PAYMENT] Descuento aplicado: código=#{discount_code.code}, descuento=#{discount_amount}, nuevo_total=#{@order.total}"
        else
          Rails.logger.warn "[PAYMENT] Código de descuento inválido o no utilizable: #{params[:discount_code_id]}"
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

      response = PayuService.create_payment(@order, current_user, card_info)

      Rails.logger.info "[PAYMENT] Respuesta PayU: #{response.inspect}"

      if response[:code] == "SUCCESS" && response[:transaction_state] == "APPROVED"
        @order.update(status: :paid)
        Rails.logger.info "[PAYMENT] Pago aprobado para order_id=#{@order.id}"
        flash[:notice] = "Pago aprobado"
      else
        error = response[:message] || "Error desconocido"
        @order.update(status: :cancelled)
        Rails.logger.error "[PAYMENT] Pago fallido para order_id=#{@order.id} - Motivo: #{error}"
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
