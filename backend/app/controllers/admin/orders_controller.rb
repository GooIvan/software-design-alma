class Admin::OrdersController < ApplicationController
  layout 'admin'

  def index
    @orders = Order.all
  end

  def show
    @order = Order.includes(order_items: :product).find(params[:id])
  end
end
