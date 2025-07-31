class Category < ApplicationRecord
  # * Dependencia de la categoría: si se elimina una categoría, se eliminan todos los productos asociados a ella.
  has_many :products, dependent: :destroy
  has_one_attached :image
  validates :name, presence: true uniqueness: { case_sensitive: false }
  validates :image, presence: true # Si deseas que la imagen sea obligatoria

  before_validation :generate_slug

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = name.parameterize if name.present? && slug.blank?
  end

end
