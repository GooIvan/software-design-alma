class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum :status, { pending: 0, paid: 1, cancelled: 2 }

  validates :total, presence: true

  accepts_nested_attributes_for :order_items, allow_destroy: true
end
