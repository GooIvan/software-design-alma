class Api::BaseController < ActionController::API
  respond_to :json
  before_action :authenticate_request

  attr_reader :current_user

  protected

  def authenticate_request
    result = AuthorizeApiRequest.new(request.headers).call
    
    if result[:success]
      @current_user = result[:user]
    else
      render json: { 
        success: false, 
        message: 'Not Authorized', 
        errors: [result[:message]] 
      }, status: 401 and return
    end
  end

  def authenticate_api_user!
    authenticate_request
  end
end
