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
