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
end
