class Api::V1::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def google_login
    begin
      # Validar que se reciban los datos necesarios
      unless params[:email].present?
        return render json: { error: 'Email es requerido' }, status: :bad_request
      end

      # Buscar usuario existente por email Y provider (para diferenciar de login normal)
      user = User.find_by(email: params[:email], provider: 'google_oauth2')
      
      # Si no existe, crear uno nuevo
      unless user
        # Generar un UID único basado en el email para Google OAuth
        google_uid = "google_#{Digest::SHA256.hexdigest(params[:email])}"
        
        user = User.new(
          email: params[:email],
          provider: 'google_oauth2',
          uid: google_uid,
          password: Devise.friendly_token[0, 20],
          name: params[:name]&.split(' ')&.first || 'Usuario',
          last_name: params[:name]&.split(' ')&.last || 'Google',
          city: 'N/A',
          phone: 'N/A',
          address: 'N/A'
        )
        
        unless user.save
          Rails.logger.error "Error guardando usuario Google: #{user.errors.full_messages.join(', ')}"
          return render json: {
            success: false,
            error: 'No se pudo crear el usuario',
            errors: user.errors.full_messages
          }, status: :unprocessable_entity
        end
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
