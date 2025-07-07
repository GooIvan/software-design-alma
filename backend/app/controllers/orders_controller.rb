class OrdersController < ApplicationController
  def create
    @order = current_user.orders.new(status: "pending", total: calculate_cart_total)

    current_cart.items.each do |item|
      @order.order_items.build(
        product: item.product,
        quantity: item.quantity,
        size: item.size,
        price: item.product.price
      )
    end

    if @order.save
      clear_cart
      redirect_to @order, notice: "Orden creada con éxito"
    else
      redirect_to cart_path, alert: "No se pudo crear la orden"
    end
  end

  def show
  end
end
