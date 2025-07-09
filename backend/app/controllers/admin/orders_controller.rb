class Admin::OrdersController < ApplicationController
  layout 'admin'

  def index
    @orders = Order.all
    @order = Order.first
  end

  def show
    @order = Order.includes(order_items: :product).find(params[:id])
  end

  def new
    @order = Order.new
    @products = Product.all
    @categories = Category.all
    1.times { @order.order_items.build }
  end

  def create
    @order = Order.new(order_params)
    @order.total = 0

    @order.order_items.each do |item|
      item.price = Product.find(item.product_id).price
      @order.total += item.price * item.quantity
    end

    if @order.save
      redirect_to admin_orders_path, notice: "Orden creada exitosamente."
    else
      @products = Product.all
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to admin_orders_path, notice: "Orden eliminada correctamente."
  end

  private

  def order_params
    params.require(:order).permit(
      :user_id,
      :status,
      :total,
      order_items_attributes: [:product_id, :quantity, :size]
    )
  end
end
