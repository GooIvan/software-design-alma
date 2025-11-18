class Api::OrdersController < Api::BaseController
  before_action :set_order, only: [:show, :cancel, :update_status]

  # Bloquear compras si el perfil está incompleto
  before_action :ensure_profile_complete, only: [:create]

  # ==============================
  # GET /api/orders
  # ==============================
  def index
    @orders = current_user.orders
                          .includes(order_items: :product)
                          .order(created_at: :desc)

    render json: success_response(orders: @orders.map { order_json(_1) })
  end

  # ==============================
  # GET /api/orders/history
  # ==============================
  def history
    @orders = current_user.orders
                          .includes(order_items: :product)
                          .where.not(status: %w[pending processing])
                          .order(created_at: :desc)

    render json: success_response(orders: @orders.map { order_json(_1) })
  end

  # ==============================
  # GET /api/orders/active
  # ==============================
  def active
    @orders = current_user.orders
                          .includes(order_items: :product)
                          .where(status: %w[pending processing confirmed])
                          .order(created_at: :desc)

    render json: success_response(orders: @orders.map { order_json(_1) })
  end

  # ==============================
  # GET /api/orders/:id
  # ==============================
  def show
    render json: success_response(order: order_detail_json(@order))
  end

  # ==============================
  # POST /api/orders
  # ==============================
  def create
    @order = current_user.orders.build(status: :pending)

    unless valid_items_params?
      return error("Debe enviar al menos un producto en la orden", :unprocessable_entity)
    end

    begin
      add_items_to_order(params[:items])
    rescue => e
      return error("Error al procesar los productos: #{e.message}", :unprocessable_entity)
    end

    if @order.save
      render json: success_response(
        message: "Orden creada exitosamente",
        order: order_detail_json(@order)
      ), status: :created
    else
      error("Error al crear la orden", :unprocessable_entity, @order.errors.full_messages)
    end
  end

  # ==============================
  # PATCH /api/orders/:id/cancel
  # ==============================
  def cancel
    unless @order.pending?
      return error("Solo se pueden cancelar órdenes pendientes", :unprocessable_entity)
    end

    @order.update(status: :cancelled)

    render json: success_response(
      message: "Orden cancelada exitosamente",
      order: order_json(@order)
    )
  end

  # ==============================
  # PATCH /api/orders/:id/update_status (admin)
  # ==============================
  def update_status
    if @order.update(status: params[:status])
      render json: success_response(
        message: "Estado de orden actualizado",
        order: order_json(@order)
      )
    else
      error("Error al actualizar el estado", :unprocessable_entity, @order.errors.full_messages)
    end
  end

  # ==============================
  # MÉTODOS DE PAGO
  # ==============================
  def payment_methods
    render json: success_response(
      payment_methods: [
        {
          id: 'card',
          name: 'Tarjeta de Crédito/Débito',
          description: 'Pago seguro con tarjeta',
          enabled: true
        },
        {
          id: 'paypal',
          name: 'PayPal',
          description: 'Pago a través de PayPal',
          enabled: false
        }
      ]
    )
  end

  # ==============================
  # PRIVATE
  # ==============================
  private

  # ==============================
  # BLOQUEAR COMPRA SI PERFIL INCOMPLETO
  # ==============================
  def ensure_profile_complete
    return if current_user.profile_complete?

    render json: {
      success: false,
      message: "Debes completar tu perfil antes de realizar compras",
      missing_fields: incomplete_fields
    }, status: :forbidden
  end

  def incomplete_fields
    %w[name last_name city phone address].select { |f| current_user.send(f).blank? }
  end

  # ==============================
  # RESPUESTAS
  # ==============================
  def success_response(data)
    { success: true }.merge(data)
  end

  def error(message, status, errors = nil)
    render json: {
      success: false,
      message: message,
      errors: errors
    }.compact, status: status
  end

  # ==============================
  # VALIDACIONES
  # ==============================
  def valid_items_params?
    params[:items].is_a?(Array) && params[:items].any?
  end

  # ==============================
  # BUSCAR ORDEN
  # ==============================
  def set_order
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    error("Orden no encontrada", :not_found)
  end

  # ==============================
  # JSON BÁSICO
  # ==============================
  def order_json(order)
    {
      id: order.id,
      order_number: "ORD-#{order.id.to_s.rjust(8, '0')}",
      status: order.status,
      status_display: order.status&.humanize,
      total: order.total,
      items_count: order.order_items.size,
      created_at: order.created_at.iso8601,
      updated_at: order.updated_at.iso8601
    }
  end

  # ==============================
  # JSON DETALLADO
  # ==============================
  def order_detail_json(order)
    order_json(order).merge(
      order_items: order.order_items.map do |item|
        {
          id: item.id,
          product_id: item.product_id,
          product_name: item.product.name,
          size: item.size,
          quantity: item.quantity,
          price: item.price,
          total_price: item.price * item.quantity,
          product_image: item.product.image.present? ? url_for(item.product.image) : nil
        }
      end
    )
  end

  # ==============================
  # AÑADIR ITEMS
  # ==============================
  def add_items_to_order(items_params)
    items_params.each do |item|
      raise "Cada producto debe tener product_id y quantity" if item[:product_id].blank? || item[:quantity].blank?

      quantity = item[:quantity].to_i
      raise "La cantidad debe ser mayor a 0" if quantity <= 0

      product = Product.find(item[:product_id])

      @order.order_items.build(
        product: product,
        quantity: quantity,
        size: item[:size],
        price: product.price
      )
    end
  end
end
