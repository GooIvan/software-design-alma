class Api::ProfileController < Api::BaseController

  # GET /api/profile
  def show
    render json: {
      success: true,
      user: serialize_user(current_user)
    }, status: :ok
  end

  # PATCH /api/profile
  def update
    if current_user.update(profile_params)
      render json: {
        success: true,
        message: "Perfil actualizado correctamente",
        user: serialize_user(current_user)
      }, status: :ok
    else
      render json: {
        success: false,
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  # Solo permitimos modificación de campos del perfil
  def profile_params
    params.require(:user)
          .permit(:name, :last_name, :city, :phone, :address)
          .transform_values { |v| v.presence } # evitar strings vacíos
  end

  # Ensamblar la respuesta del usuario
  def serialize_user(user)
    {
      id: user.id,
      email: user.email,
      name: user.name,
      last_name: user.last_name,
      city: user.city,
      phone: user.phone,
      address: user.address,
      role: user.role,
      profile_complete: user.profile_complete?
    }
  end
end
