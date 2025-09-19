class Api::Auth::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token
  skip_before_action :redirect_to_default_locale, if: :api_request?
  skip_before_action :set_locale, if: :api_request?
  skip_before_action :load_categories, if: :api_request?
  before_action :authenticate_request, only: [:destroy]

  # POST /api/auth/sign_in
  def create
    user = User.find_by(email: params[:user][:email])
    
    if user && user.valid_password?(params[:user][:password])
      # Generate JWT token
      token = JwtService.encode(user_id: user.id)
      
      render json: {
        success: true,
        message: "Logged in successfully",
        token: token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          last_name: user.last_name,
          city: user.city,
          phone: user.phone,
          address: user.address
        }
      }, status: :ok
    else
      render json: {
        success: false,
        message: "Invalid email or password",
        errors: ["Invalid email or password"]
      }, status: :unauthorized
    end
  end

  # DELETE /api/auth/sign_out
  def destroy
    # Get token from Authorization header
    auth_header = request.headers['Authorization']
    token = auth_header&.split(' ')&.last
    
    if token
      # Add token to blacklist
      JwtDenylist.create!(jti: token)
      
      render json: {
        success: true,
        message: "Logged out successfully"
      }, status: :ok
    else
      render json: {
        success: false,
        message: "No token provided"
      }, status: :bad_request
    end
  end

  private

  def authenticate_request
    auth_request = AuthorizeApiRequest.new(request.headers)
    result = auth_request.call
    
    unless result[:success]
      render json: {
        success: false,
        message: "Unauthorized",
        errors: [result[:message]]
      }, status: :unauthorized and return
    end
    
    @current_user = result[:user]
  end

  def api_request?
    request.format.json?
  end

  def respond_with(resource, _opts = {})
    token = JwtService.encode(user_id: resource.id)
    render json: {
      success: true,
      message: "Logged in successfully",
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
  end

  def respond_to_on_destroy
    render json: {
      success: true,
      message: "Logged out successfully"
    }, status: :ok
  end
end
