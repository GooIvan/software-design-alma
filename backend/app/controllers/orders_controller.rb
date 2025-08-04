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

    @order = Order.create!(
      user: current_user,
      status: :pending,
      order_items_attributes: order_items_attributes,
    )

    current_cart.cart_items.destroy_all

    redirect_to payment_order_path(@order), notice: "Orden creada. Procede al pago."
  end

  def payment
    @order = Order.find(params[:id])

    unless @order.user == current_user && @order.pending?
      redirect_to root_path, alert: "No autorizado o la orden ya fue pagada."
    end
  end

  def pay_with_card
    @order = Order.find(params[:id])

    unless @order.user == current_user && @order.pending?
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

      response = PayuService.create_payment(@order, current_user, card_info)

      if response[:code] == "SUCCESS" && response[:transaction_state] == "APPROVED"
        @order.update(status: :paid)
        flash[:notice] = "Pago aprobado"
      else
        error = response[:message] || "Error desconocido"
        @order.update(status: :cancelled)
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
