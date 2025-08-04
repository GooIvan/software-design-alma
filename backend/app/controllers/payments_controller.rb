class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:confirmation] # PayU no envía CSRF token

  # PayU redirige aquí después del pago
  def success
    @order = Order.find_by(id: params[:referenceCode])
    flash[:notice] = "Pago exitoso para la orden ##{@order.id}" if @order
    redirect_to root_path
  end

  # PayU hace POST aquí para notificar el estado real del pago
  def confirmation
    order = Order.find_by(id: params[:reference_sale])

    if order && valid_signature?(params)
      if params[:state_pol] == "4" # 4 = Aprobada
        order.update(status: :paid)
      else
        order.update(status: :rejected)
      end
      head :ok
    else
      head :unauthorized
    end
  end

  private

  def valid_signature?(params)
    api_key = "4Vj8eK4rloUd272L48hsrarnUA" # clave sandbox pública de PayU Colombia
    signature_string = [
      api_key,
      params[:merchant_id],
      params[:reference_sale],
      params[:value].to_f.round(1), # PayU redondea a 1 decimal
      params[:currency],
      params[:state_pol]
    ].join("~")

    expected_signature = Digest::MD5.hexdigest(signature_string)
    expected_signature == params[:sign]
  end
end
