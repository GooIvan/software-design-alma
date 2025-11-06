class DiscountCode < ApplicationRecord
  belongs_to :user, optional: true              # usuario autorizado (si aplica)
  belongs_to :created_by, class_name: "User", optional: true

  has_many :discount_usages, dependent: :destroy
  has_many :users, through: :discount_usages
  has_many :orders, through: :discount_usages

  validates :code, presence: true, uniqueness: true
  validates :discount_type, inclusion: { in: %w[percentage fixed_amount] }
  validates :value, numericality: { greater_than: 0 }

  # --- Métodos de estado ---
  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def active?
    !expired? && active
  end

  def percentage?
    discount_type == "percentage"
  end

  def fixed_amount?
    discount_type == "fixed_amount"
  end

  # --- Lógica de uso ---
  def usable_by?(current_user)
    return false unless active?
    return false if expired?
    return false if user.present? && user != current_user
    return false if max_uses && discount_usages.count >= max_uses
    return false if max_uses_per_user && discount_usages.where(user: current_user).count >= max_uses_per_user
    true
  end

  def apply_to(subtotal)
    return 0 unless active?

    if percentage?
      (subtotal * (value / 100.0)).round(2)
    else
      [value, subtotal].min
    end
  end
end
