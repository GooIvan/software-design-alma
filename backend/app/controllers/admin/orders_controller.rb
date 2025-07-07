class Admin::OrdersController < ApplicationController
  layout 'admin'

  def index
    @orders = Order.all
  end

  def show
    @order = Order.includes(order_items: :product).find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to admin_orders_path, notice: "Orden eliminada correctamente."
  end
end
