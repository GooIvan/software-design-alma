class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :product

  # Evitar duplicados: un usuario no puede marcar un producto más de una vez
  validates :user_id, uniqueness: { scope: :product_id, message: "ya marcó este producto como favorito" }

  # Opcional pero recomendable: asegurar presencia
  validates :user_id, :product_id, presence: true
end
