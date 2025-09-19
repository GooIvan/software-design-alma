class Api::Auth::PasswordsController < Devise::PasswordsController
  respond_to :json
  skip_before_action :verify_authenticity_token
  skip_before_action :redirect_to_default_locale
  skip_before_action :set_locale
  skip_before_action :load_categories

  # POST /api/auth/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      render json: {
        success: true,
        message: "Reset password instructions sent to your email"
      }, status: :ok
    else
      render json: {
        success: false,
        message: "Email not found",
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/auth/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      render json: {
        success: true,
        message: "Password reset successfully"
      }, status: :ok
    else
      render json: {
        success: false,
        message: "Password reset failed",
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end
end
