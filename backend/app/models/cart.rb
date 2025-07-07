# app/models/cart.rb
class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  def total_price
    cart_items.sum { |item| item.product.price * item.quantity }
  end

end

