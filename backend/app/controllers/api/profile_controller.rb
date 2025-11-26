class Api::ProfileController < Api::BaseController

  def show
    render json: {
      success: true,
      user: {
        id: current_user.id,
        email: current_user.email,
        name: current_user.name,
        last_name: current_user.last_name,
        city: current_user.city,
        phone: current_user.phone,
        address: current_user.address,
        role: current_user.role
      }
    }, status: :ok
  end

  def update
    Rails.logger.info "=== ACTUALIZANDO PERFIL ==="
    Rails.logger.info "Params recibidos: #{params.inspect}"
    Rails.logger.info "Profile params: #{profile_params.inspect}"
    Rails.logger.info "Usuario actual: #{current_user.inspect}"
    
    # Actualizar sin validaciones de Devise
    current_user.assign_attributes(profile_params)
    
    if current_user.save(validate: false)
      Rails.logger.info "✅ Perfil actualizado exitosamente"
      render json: {
        success: true,
        user: {
          id: current_user.id,
          email: current_user.email,
          name: current_user.name,
          last_name: current_user.last_name,
          city: current_user.city,
          phone: current_user.phone,
          address: current_user.address,
          role: current_user.role
        }
      }, status: :ok
    else
      Rails.logger.error "❌ Error al actualizar perfil: #{current_user.errors.full_messages.join(', ')}"
      render json: {
        success: false,
        errors: current_user.errors.full_messages,
        message: "Error al actualizar perfil"
      }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "❌ Excepción al actualizar perfil: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: {
      success: false,
      error: e.message
    }, status: :internal_server_error
  end

  private

  def profile_params
    params.permit(:name, :last_name, :phone, :address, :city)
  end
end
