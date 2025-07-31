class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum :status, { pending: 0, paid: 1, cancelled: 2 }

  validates :total, presence: true

  accepts_nested_attributes_for :order_items, allow_destroy: true

  before_validation :set_item_prices_and_total

  def self.cleanup_empty!
    Order.left_joins(:order_items).where(order_items: { id: nil }).destroy_all
  end

  private

  def set_item_prices_and_total
    self.total = 0
    order_items.each do |item|
      next unless item.product_id.present?

      product = Product.find_by(id: item.product_id)
      if product
        item.price = product.price
        self.total += item.price * item.quantity.to_i
      end
    end
  end
end
