class OrdersController < ApplicationController
  before_action :authenticate_user!  # ← esto redirige al login si no hay sesión
  
  def create
    if current_cart.cart_items.empty?
      redirect_back fallback_location: root_path, alert: "El carrito está vacío."
      return
    end

    # Construir los atributos para order_items desde el carrito
    order_items_attributes = current_cart.cart_items.map do |item|
      {
        product_id: item.product.id,
        quantity: item.quantity,
        size: item.size
      }
    end

    # Crear la orden con los items (el modelo calculará los precios y total)
    @order = Order.create!(
      user: current_user,
      status: :pending,
      order_items_attributes: order_items_attributes
    )

    # Vaciar el carrito
    current_cart.cart_items.destroy_all

    redirect_back fallback_location: root_path(locale: I18n.locale), notice: "Orden creada exitosamente."
  end
end
