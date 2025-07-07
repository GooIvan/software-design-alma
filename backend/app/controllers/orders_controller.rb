class OrdersController < ApplicationController
  before_action :authenticate_user!  # ← esto redirige al login si no hay sesión
  
  def create
    if current_cart.cart_items.empty?
      redirect_back fallback_location: root_path, alert: "El carrito está vacío."
      return
    end

    # Crear orden con usuario actual (o temporal si no hay login)
    @order = Order.create!(
      user: current_user,  # o User.first si estás en desarrollo
      status: :pending,
      total: current_cart.cart_items.sum { |item| item.product.price * item.quantity }
    )

    # Agregar items de carrito
    current_cart.cart_items.each do |cart_item|
      @order.order_items.create!(
        product: cart_item.product,
        size: cart_item.size,
        quantity: cart_item.quantity,
        price: cart_item.product.price
      )
    end

    # Vaciar carrito
    current_cart.cart_items.destroy_all

    redirect_back fallback_location: root_path(locale: I18n.locale), notice: "Orden creada exitosamente."
  end
end
