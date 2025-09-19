class Api::LogoutController < ActionController::API
  respond_to :json

  def create
    # Get token from Authorization header
    auth_header = request.headers['Authorization']
    token = auth_header&.split(' ')&.last
    
    if token.present?
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
end
