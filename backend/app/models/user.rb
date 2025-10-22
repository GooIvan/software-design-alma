class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Relaciones
  has_many :orders, dependent: :destroy

  # Validaciones de presencia y longitud mínima
  validates :name, :last_name, :city, :phone, :address, presence: true, if: :password_required?

  # Validación de formato de email
  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX, message: "El formato del correo no es válido" },
                    uniqueness: { message: "Este correo ya está registrado" }

  def admin?
    role == "admin"
  end

  # Método para crear usuario desde OmniAuth
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.first_name || auth.info.name || "Usuario"
      user.last_name = auth.info.last_name || "Google"
      user.city = "N/A"
      user.phone = "N/A"
      user.address = "N/A"
    end
  end

  private

  def password_required?
    provider.blank?
  end
end
