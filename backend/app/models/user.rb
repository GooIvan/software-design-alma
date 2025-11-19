class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  # Relaciones
  has_many :orders, dependent: :destroy

  # Validaciones de presencia y longitud mínima
  validates :name, :last_name, :city, :phone, :address,
            presence: true,
            if: :requires_profile_fields?

  # Validación de formato de email
  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX, message: "El formato del correo no es válido" },
                    uniqueness: { message: "Este correo ya está registrado" },
                    unless: -> { provider.present? && email&.ends_with?('@designalma.temp') }

  def admin?
    role == "admin"
  end

  # Método para crear usuario desde OmniAuth
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.provider}-#{auth.uid}@designalma.temp"
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.first_name || auth.info.name&.split(' ')&.first || "Usuario"
      user.last_name = auth.info.last_name || auth.info.name&.split(' ')&.last || "Facebook"
      user.city = "N/A"
      user.phone = "N/A"
      user.address = "N/A"
    end
  end

  private

  #    - Para usuarios normales: exige datos al crear
  #    - Para edición: NO exige contraseña si no se está cambiando
  def password_required?
    return false if provider.present?          # Usuarios social login → nunca piden password
    return true if new_record?                # Registro normal → sí pide password
    password.present? || password_confirmation.present?
  end

  # 👉 Campos obligatorios solo en registro, no al editar
  def requires_profile_fields?
    new_record? || password_required?
  end
end
