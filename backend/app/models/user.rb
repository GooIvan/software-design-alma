class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  # Validaciones de presencia y longitud mínima
  validates :name, :last_name, :city, :phone, :address, presence: true

  # Validación de formato de email
  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/
  validates :email, presence: true,
            format: { with: VALID_EMAIL_REGEX, message: "El formato del correo no es válido" },
            uniqueness: { message: "Este correo ya está registrado" }

  def admin?
    role == "admin"
  end
end
