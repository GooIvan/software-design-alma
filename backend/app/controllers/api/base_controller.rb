class Api::BaseController < ApplicationController
  include Devise::Controllers::Helpers if defined?(Devise)
  
  respond_to :json
  before_action :authenticate_request
  skip_before_action :verify_authenticity_token
  
  before_action :ensure_session_loaded

  attr_reader :current_user
  
  private
  
  def ensure_session_loaded
    session.loaded?
  end

  protected

  def authenticate_request
    warden = request.env['warden']

    # Primero intentar autenticación JWT (para apps móviles)
    if request.headers['Authorization'].present?
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
    # Si no hay JWT, intentar autenticación por sesión (para navegador)
    else
      
      # Método 1: Usar Warden directamente (más confiable)
      if warden && warden.user
        @current_user = warden.user
      # Método 2: Usar helpers de Devise
      elsif respond_to?(:user_signed_in?) && user_signed_in?
        @current_user = current_user
      # Método 3: Buscar en sesión manualmente
      elsif session['warden.user.user.key'].present?
        user_id = session['warden.user.user.key'][0][0]
        @current_user = User.find_by(id: user_id)
      else
        render json: { 
          success: false, 
          message: 'Not Authorized', 
          errors: ['Please login first. Make sure you are logged in the main app.'] 
        }, status: 401 and return
      end
    end
  end

  def authenticate_api_user!
    authenticate_request
  end
end
