class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, :price, :size, presence: true
  validate :stock_is_available

  private

  def stock_is_available
    return unless product && quantity

    if product.stock < quantity
      errors.add(:product, I18n.t("order.cart.not_stock", product: product.name, stock: product.stock))
    end
  end
end
