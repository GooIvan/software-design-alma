class Api::OrdersController < Api::BaseController
  before_action :set_order, only: [:show, :cancel, :update_status]

  # GET /api/orders
  def index
    @orders = current_user.orders.includes(:order_items).order(created_at: :desc)
    
    render json: {
      success: true,
      orders: @orders.map { |order| order_json(order) }
    }
  end

  # GET /api/orders/history
  def history
    @orders = current_user.orders
                         .includes(:order_items)
                         .where.not(status: ['pending', 'processing'])
                         .order(created_at: :desc)
    
    render json: {
      success: true,
      orders: @orders.map { |order| order_json(order) }
    }
  end

  # GET /api/orders/active
  def active
    @orders = current_user.orders
                         .includes(:order_items)
                         .where(status: ['pending', 'processing', 'confirmed'])
                         .order(created_at: :desc)
    
    render json: {
      success: true,
      orders: @orders.map { |order| order_json(order) }
    }
  end

  # GET /api/orders/:id
  def show
    render json: {
      success: true,
      order: order_detail_json(@order)
    }
  end

  # POST /api/orders
  def create
    @order = current_user.orders.build(status: 'pending')
    
    # Validar que se envíen items
    unless params[:items].present? && params[:items].is_a?(Array) && params[:items].any?
      return render json: {
        success: false,
        message: "Debe enviar al menos un producto en la orden"
      }, status: :unprocessable_entity
    end

    # Agregar items a la orden
    begin
      add_items_to_order(params[:items])
    rescue => e
      return render json: {
        success: false,
        message: "Error al procesar los productos: #{e.message}"
      }, status: :unprocessable_entity
    end

    # Aplicar descuento si existe
    discount_amount = 0
    if params[:discount_code].present?
      discount_code = DiscountCode.find_by(code: params[:discount_code])
      
      if discount_code.nil?
        return render json: {
          success: false,
          message: "Código de descuento no encontrado"
        }, status: :unprocessable_entity
      end
      
      unless discount_code.usable_by?(current_user)
        return render json: {
          success: false,
          message: "El código de descuento no es válido, ha expirado o ya fue utilizado"
        }, status: :unprocessable_entity
      end
      
      subtotal = @order.order_items.sum { |item| item.price * item.quantity }
      discount_amount = discount_code.apply_to(subtotal)
      
      @order.discount_code = discount_code
      @order.discount_amount = discount_amount
      @order.total = subtotal - discount_amount
    end

    if @order.save
      # Crear registro de uso del descuento si aplica
      if @order.discount_code.present? && discount_amount > 0
        DiscountUsage.create!(
          discount_code: @order.discount_code,
          user: current_user,
          order: @order,
          discount_amount: discount_amount
        )
      end
      
      render json: {
        success: true,
        message: "Orden creada exitosamente",
        order: order_detail_json(@order)
      }, status: :created
    else
      render json: {
        success: false,
        message: "Error al crear la orden",
        errors: @order.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH /api/orders/:id/cancel
  def cancel
    if @order.status == 'pending'
      @order.update(status: 'cancelled')
      render json: {
        success: true,
        message: "Orden cancelada exitosamente",
        order: order_json(@order)
      }
    else
      render json: {
        success: false,
        message: "Solo se pueden cancelar órdenes pendientes"
      }, status: :unprocessable_entity
    end
  end

  # PATCH /api/orders/:id/update_status (solo admin)
  def update_status
    # TODO: Agregar verificación de admin
    if @order.update(status: params[:status])
      render json: {
        success: true,
        message: "Estado de orden actualizado",
        order: order_json(@order)
      }
    else
      render json: {
        success: false,
        message: "Error al actualizar el estado",
        errors: @order.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # GET /api/orders/:id/payment_methods
  def payment_methods
    render json: {
      success: true,
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
    }
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      message: "Orden no encontrada"
    }, status: :not_found
  end

  def order_params
    # Ya no necesitamos params de order porque la orden se crea directamente
    {}
  end

  def order_json(order)
    # Obtener información de descuento
    discount_amount = order.discount_amount || 0
    if discount_amount == 0 && order.discount_usage.present?
      discount_amount = order.discount_usage.discount_amount
    end
    
    {
      id: order.id,
      order_number: "ORD-#{order.id.to_s.rjust(8, '0')}",
      status: order.status,
      status_display: order.status&.humanize,
      total: order.total,
      subtotal: order.order_items.sum { |item| item.price * item.quantity },
      discount: {
        code: order.discount_code&.code,
        amount: discount_amount,
        applied: discount_amount > 0
      },
      items_count: order.order_items.count,
      created_at: order.created_at.iso8601,
      updated_at: order.updated_at.iso8601
    }
  end

  def order_detail_json(order)
    # Obtener información de descuento
    discount_amount = order.discount_amount || 0
    if discount_amount == 0 && order.discount_usage.present?
      discount_amount = order.discount_usage.discount_amount
    end
    
    subtotal = order.order_items.sum { |item| item.price * item.quantity }
    
    {
      id: order.id,
      order_number: "ORD-#{order.id.to_s.rjust(8, '0')}",
      status: order.status,
      status_display: order.status&.humanize,
      subtotal: subtotal,
      discount: {
        code: order.discount_code&.code,
        amount: discount_amount,
        applied: discount_amount > 0,
        discount_type: order.discount_code&.discount_type,
        discount_value: order.discount_code&.value
      },
      total: order.total,
      final_total: subtotal - discount_amount,
      created_at: order.created_at.iso8601,
      updated_at: order.updated_at.iso8601,
      order_items: order.order_items.includes(:product).map do |item|
        {
          id: item.id,
          product_id: item.product_id,
          product_name: item.product.name,
          size: item.size,
          quantity: item.quantity,
          price: item.price,
          total_price: item.price * item.quantity,
          product_image: item.product.images.attached? ? url_for(item.product.images.first) : nil
        }
      end
    }
  end

  def add_items_to_order(items_params)
    items_params.each do |item_param|
      # Validar parámetros requeridos
      unless item_param[:product_id].present? && item_param[:quantity].present?
        raise "Cada producto debe tener product_id y quantity"
      end

      # Validar que la cantidad sea positiva
      quantity = item_param[:quantity].to_i
      if quantity <= 0
        raise "La cantidad debe ser mayor a 0"
      end

      # Buscar el producto
      product = Product.find(item_param[:product_id])
      
      # Crear el order item
      @order.order_items.build(
        product: product,
        quantity: quantity,
        size: item_param[:size], # opcional
        price: product.price # usar el precio actual del producto
      )
    end
  end
end