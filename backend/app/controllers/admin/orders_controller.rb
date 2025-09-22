class Admin::OrdersController < ApplicationController
  layout 'admin'

  def index
    @orders = Order.includes(:user).order(created_at: :desc)
    @statuses = Order.distinct.pluck(:status)

    status_param = params[:status].to_s.downcase

    if status_param.present? && !["all", "todas"].include?(status_param)
      @orders = @orders.where(status: params[:status])
    end

    if params[:id].present?
      @orders = @orders.where(id: params[:id])
    end

    if params[:user_email].present?
      @orders = @orders.joins(:user).where("LOWER(users.email) LIKE ?", "%#{params[:user_email].downcase}%")
      # al usar postgresql, puedes usar ILIKE para hacer una búsqueda insensible a mayúsculas y minúsculas
      # where("users.email ILIKE ?", "%#{params[:user_email]}%")
    end
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
      product = Product.find_by(id: item.product_id)

      if product && item.quantity.present?
        item.price = product.price
        @order.total += item.price * item.quantity.to_i
      else
        if product.nil?
          @order.errors.add(:base, "Producto con ID #{item.product_id} no existe.")
        end
        if item.quantity.blank?
          @order.errors.add(:base, "La cantidad es obligatoria para todos los productos.")
        end
      end
    end

    if @order.errors.any?
      @products = Product.all
      @categories = Category.all
      render :new, status: :unprocessable_entity
    elsif @order.save
      if @order.paid?
        @order.send(:decrease_stock)
      end

      redirect_to admin_orders_path, notice: "Orden creada exitosamente."
    else
      @products = Product.all
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
  end

  def bulk_delete
    Order.where(id: params[:selected_orders]).destroy_all
    redirect_to admin_orders_path, notice: "Órdenes eliminadas correctamente"
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
