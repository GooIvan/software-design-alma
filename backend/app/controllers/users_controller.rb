class UsersController < ApplicationController
  before_action :authenticate_user!

  def update_profile
    if current_user.update(profile_params)
      render json: {
        status: "ok",
        profile_complete: current_user.profile_complete?
      }, status: :ok
    else
      render json: {
        status: "error",
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(
      :name,
      :last_name,
      :city,
      :address,
      :phone
    )
  end
end
