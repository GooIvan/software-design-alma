class DataDeletionController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :callback
  
  # Endpoint para instrucciones de eliminación de datos (para Facebook)
  def instructions
    render plain: "Para solicitar la eliminación de tus datos, envía un correo a #{ENV['CONTACT_EMAIL'] || 'support@designalma.com'} con el asunto 'Eliminación de datos'."
  end

  # Callback de Facebook para confirmación de eliminación
  def callback
    signed_request = params[:signed_request]
    
    # Parsear el signed_request de Facebook
    if signed_request
      signature, payload = signed_request.split('.')
      data = JSON.parse(Base64.decode64(payload))
      
      user_id = data['user_id']
      
      # Aquí puedes registrar la solicitud de eliminación
      Rails.logger.info "[DATA DELETION] Usuario de Facebook #{user_id} solicitó eliminación de datos"
      
      # Responder a Facebook con URL de confirmación
      render json: {
        url: "#{request.base_url}/data-deletion/status",
        confirmation_code: SecureRandom.hex(10)
      }
    else
      render json: { error: "Invalid request" }, status: :bad_request
    end
  rescue => e
    Rails.logger.error "[DATA DELETION] Error: #{e.message}"
    render json: { error: "Error processing request" }, status: :internal_server_error
  end

  # Página de estado de eliminación
  def status
    render plain: "Tu solicitud de eliminación de datos está en proceso. Recibirás una confirmación por correo electrónico."
  end
end
