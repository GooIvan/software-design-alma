class Api::V1::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def google_login
    begin
      # Validar que se reciban los datos necesarios
      unless params[:email].present?
        return render json: { error: 'Email es requerido' }, status: :bad_request
      end

      # Buscar o crear usuario
      user = User.find_or_create_by(email: params[:email]) do |u|
        u.provider = 'google_oauth2'
        u.uid = params[:id_token]&.split('.')&.first || SecureRandom.uuid
        u.password = Devise.friendly_token[0, 20]
        u.name = params[:name]&.split(' ')&.first || 'Usuario'
        u.last_name = params[:name]&.split(' ')&.last || 'Google'
        u.city = 'N/A'
        u.phone = 'N/A'
        u.address = 'N/A'
      end

      if user.persisted?
        # Generar token JWT o usar Devise token
        token = generate_auth_token(user)

        render json: {
          success: true,
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            last_name: user.last_name
          },
          token: token
        }, status: :ok
      else
        render json: {
          success: false,
          error: 'No se pudo crear el usuario',
          errors: user.errors.full_messages
        }, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "Error en google_login: #{e.message}"
      render json: {
        success: false,
        error: 'Error del servidor',
        message: e.message
      }, status: :internal_server_error
    end
  end

  private

  def generate_auth_token(user)
    # Generar JWT token usando el mismo servicio que el login normal
    JwtService.encode(user_id: user.id)
  end
end
