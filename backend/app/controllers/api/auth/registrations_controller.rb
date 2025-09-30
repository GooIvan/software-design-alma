class Api::Auth::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_action :verify_authenticity_token
  skip_before_action :redirect_to_default_locale, if: :api_request?
  skip_before_action :set_locale, if: :api_request?
  skip_before_action :load_categories, if: :api_request?

  # POST /api/auth/sign_up  
  def create
    build_resource(sign_up_params)

    if resource.save
      # Generate JWT token for new user
      token = JwtService.encode(user_id: resource.id)
      
      render json: {
        success: true,
        message: "Signed up successfully",
        token: token,
        user: {
          id: resource.id,
          email: resource.email,
          name: resource.name,
          last_name: resource.last_name,
          city: resource.city,
          phone: resource.phone,
          address: resource.address
        }
      }, status: :ok
    else
      render json: {
        success: false,
        message: "User could not be created",
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def api_request?
    request.format.json?
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :last_name, :city, :phone, :address)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      token = JwtService.encode(user_id: resource.id)
      render json: {
        success: true,
        message: "Signed up successfully",
        token: token,
        user: {
          id: resource.id,
          email: resource.email,
          name: resource.name,
          last_name: resource.last_name,
          city: resource.city,
          phone: resource.phone,
          address: resource.address
        }
      }, status: :ok
    else
      render json: {
        success: false,
        message: "User could not be created",
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
