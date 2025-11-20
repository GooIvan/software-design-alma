class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :invoice, dependent: :destroy
  belongs_to :discount_code, optional: true
  has_one :discount_usage, dependent: :destroy

  enum :status, { pending: 0, paid: 1, cancelled: 2 }

  after_update :decrease_stock, if: :status_changed_to_paid?
  after_update :create_invoice, if: :status_changed_to_paid?
  after_update :update_invoice_status, if: :saved_change_to_status?

  validates :total, presence: true
  accepts_nested_attributes_for :order_items, allow_destroy: true

  # Remover el callback automático para evitar conflictos con descuentos
  # before_validation :set_item_prices_and_total

  # Método público para calcular total sin descuento
  def calculate_total_without_discount
    subtotal = 0
    order_items.each do |item|
      next unless item.product_id.present?

      product = Product.find_by(id: item.product_id)
      if product
        item.price = product.price
        subtotal += item.price * item.quantity.to_i
      end
    end
    self.total = subtotal
  end

  public :calculate_total_without_discount

  private

  def set_item_prices_and_total
    # Si ya tiene discount_amount establecido, no recalcular el total
    # porque significa que ya fue calculado correctamente en el controlador
    return if discount_amount.present? && discount_amount > 0
    
    subtotal = 0
    order_items.each do |item|
      next unless item.product_id.present?

      product = Product.find_by(id: item.product_id)
      if product
        item.price = product.price
        subtotal += item.price * item.quantity.to_i
      end
    end
    
    self.total = subtotal
  end

  def discount_display
    return nil unless discount_code.present?
    
    if discount_code.discount_type == "percentage"
      discount_value = (total * discount_code.value / 100.0).round(0)
    else
      discount_value = discount_code.value
    end

    { 
      code: discount_code.code, 
      amount: discount_value 
    }
  end

  def decrease_stock
    transaction do
      order_items.each do |item|
        product = item.product
        next unless product.present?

        if product.stock >= item.quantity
          product.update!(stock: product.stock - item.quantity)
        else
          raise ActiveRecord::Rollback, "Stock insuficiente para #{product.name}"
        end
      end
    end
  end

  def status_changed_to_paid?
    saved_change_to_status? && paid?
  end

  def create_invoice
    return if invoice.present?

    Invoice.generate_for_order(self)
  rescue => e
    Rails.logger.error "Error creating invoice for order #{id}: #{e.message}"
  end

  def update_invoice_status
    return unless invoice.present?

    invoice.save! # Esto activará el callback sync_status_with_order
  rescue => e
    Rails.logger.error "Error updating invoice status for order #{id}: #{e.message}"
  end
end
