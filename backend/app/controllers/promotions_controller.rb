class PromotionsController < ApplicationController
  def index
    # Productos destacados (puedes personalizar la lógica)
    @featured_products = Product.includes(:category, images_attachments: :blob)
                               .where.not(stock: 0)
                               .order('RANDOM()')
                               .limit(8)
    
    # Códigos de descuento activos y públicos (sin usuario específico)
    @active_discount_codes = DiscountCode.where(active: true, user_id: nil)
                                        .where('expires_at IS NULL OR expires_at > ?', Time.current)
                                        .order(created_at: :desc)
    
    # Productos más vendidos (con manejo de errores si no hay ventas)
    begin
      @bestsellers = Product.includes(:category, images_attachments: :blob)
                           .joins(:order_items)
                           .joins("INNER JOIN orders ON order_items.order_id = orders.id")
                           .where(orders: { status: :paid })
                           .select('products.*, COUNT(order_items.id) as sales_count')
                           .group('products.id')
                           .order('sales_count DESC')
                           .limit(6)
    rescue ActiveRecord::StatementInvalid
      @bestsellers = []
    end
    
    # Productos recientes (últimos 2 meses)
    @new_arrivals = Product.includes(:category, images_attachments: :blob)
                          .where('created_at >= ?', 2.months.ago)
                          .where.not(stock: 0)
                          .order(created_at: :desc)
                          .limit(8)
  rescue => e
    Rails.logger.error "Error en promotions#index: #{e.message}"
    @featured_products ||= []
    @active_discount_codes ||= []
    @bestsellers ||= []
    @new_arrivals ||= []
  end
end
