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
    subtotal = 0

    # Calcular subtotal
    @order.order_items.each do |item|
      product = Product.find_by(id: item.product_id)

      if product && item.quantity.present?
        item.price = product.price
        subtotal += item.price * item.quantity.to_i
      else
        if product.nil?
          @order.errors.add(:base, "Producto con ID #{item.product_id} no existe.")
        end
        if item.quantity.blank?
          @order.errors.add(:base, "La cantidad es obligatoria para todos los productos.")
        end
      end
    end

    # Aplicar descuento si existe
    discount_amount = 0
    if @order.discount_code.present?
      # Para órdenes creadas por admin, validar usabilidad por el usuario de la orden
      target_user = @order.user
      unless @order.discount_code.usable_by?(target_user)
        @order.errors.add(:discount_code, "El código de descuento no es válido para este usuario o ha expirado")
      else
        discount_amount = @order.discount_code.apply_to(subtotal)
        @order.discount_amount = discount_amount
      end
    end

    # Establecer el total final (con o sin descuento)
    @order.total = subtotal - discount_amount

    if @order.errors.any?
      @products = Product.all
      @categories = Category.all
      render :new, status: :unprocessable_entity
    elsif @order.save
      # Crear registro de uso del descuento si aplica
      if @order.discount_code.present? && discount_amount > 0
        DiscountUsage.create!(
          discount_code: @order.discount_code,
          user: @order.user,
          order: @order,
          discount_amount: discount_amount
        )
      end

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
      :discount_code_id,
      order_items_attributes: [:product_id, :quantity, :size]
    )
  end
end
