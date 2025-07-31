class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image

  # * Se definen las tallas disponibles para la creación de los productos 
  serialize :sizes, coder: JSON
  SIZES = %w[XS S M L XL XXL BIG MEDIUM SMALL]

  before_validation :normalize_sizes
  validate :sizes_must_be_valid

  # * Validar que el stock sea un número mayor o igual a 0
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :name, :price, :stock, :category_id, :image, presence: true

  # *
  has_many :cart_items
  has_many :order_items, dependent: :destroy

  def formatted_price
    ActionController::Base.helpers.number_to_currency(price, unit: "", separator: ",", delimiter: ".", precision: 0)
  end

  def normalize_sizes
    self.sizes = Array(sizes).reject(&:blank?)
  end

  def sizes_must_be_valid
    invalid = sizes - SIZES
    errors.add(:sizes, "contiene tallas inválidas: #{invalid.join(', ')}") if invalid.any?
  end
end
