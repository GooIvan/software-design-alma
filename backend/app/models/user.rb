class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  # Relaciones
  has_many :orders, dependent: :destroy

  # VALIDACIONES SOLO PARA USUARIOS NORMALES (los sociales no pasan por aquí)
  validates :name, :last_name, :city, :phone, :address,
            presence: true,
            unless: :social_login?

  # Validación de email
  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX, message: "El formato del correo no es válido" },
            uniqueness: { message: "Este correo ya está registrado" },
            unless: -> { social_login? && email&.ends_with?('@designalma.temp') }

  # Crear usuario desde Google/Facebook
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      # Email (temporal si falta)
      user.email = auth.info.email || "#{auth.provider}-#{auth.uid}@designalma.temp"

      # Password autogenerado para usuarios sociales
      user.password = Devise.friendly_token[0, 20] if user.encrypted_password.blank?

      # Nombre
      user.name = auth.info.first_name || auth.info.name&.split(" ")&.first || user.name
      user.last_name = auth.info.last_name || auth.info.name&.split(" ")&.last || user.last_name

      # Datos que se completarán luego en la edición de perfil
      user.city ||= nil
      user.phone ||= nil
      user.address ||= nil

      user.save
    end
  end

  # Verificar si el perfil está completo
  def profile_complete?
    name.present? &&
    last_name.present? &&
    city.present? &&
    phone.present? &&
    address.present?
  end

  # Rol administrador
  def admin?
    role == "admin"
  end

  private

  # Determinar si el usuario inició sesión con Google/Facebook
  def social_login?
    provider.present?
  end
end
