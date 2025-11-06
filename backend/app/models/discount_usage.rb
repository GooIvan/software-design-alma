class DiscountUsage < ApplicationRecord
  belongs_to :discount_code
  belongs_to :user, optional: true
  belongs_to :order, optional: true

  validates :discount_code, presence: true
end
