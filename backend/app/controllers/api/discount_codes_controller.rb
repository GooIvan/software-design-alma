class Api::DiscountCodesController < Api::BaseController

  # POST /api/discount_codes/validate
  def validate
    unless params[:code].present?
      return render json: {
        success: false,
        message: "Debe proporcionar un código de descuento"
      }, status: :unprocessable_entity
    end

    discount_code = DiscountCode.find_by(code: params[:code])

    if discount_code.nil?
      return render json: {
        success: false,
        message: "Código de descuento no encontrado",
        valid: false
      }, status: :not_found
    end

    unless discount_code.usable_by?(current_user)
      reason = get_invalid_reason(discount_code)
      return render json: {
        success: false,
        message: reason,
        valid: false
      }, status: :unprocessable_entity
    end

    # Calcular descuento si se proporciona un subtotal
    discount_amount = 0
    if params[:subtotal].present?
      subtotal = params[:subtotal].to_f
      discount_amount = discount_code.apply_to(subtotal)
    end

    render json: {
      success: true,
      message: "Código de descuento válido",
      valid: true,
      discount_code: {
        code: discount_code.code,
        discount_type: discount_code.discount_type,
        value: discount_code.value,
        description: get_discount_description(discount_code),
        discount_amount: discount_amount,
        remaining_uses: get_remaining_uses(discount_code),
        expires_at: discount_code.expires_at&.iso8601
      }
    }
  end

  # GET /api/discount_codes/available
  def available
    discount_codes = DiscountCode.where(active: true)
                                 .where('expires_at IS NULL OR expires_at > ?', Time.current)
                                 .where('user_id IS NULL OR user_id = ?', current_user.id)

    available_codes = discount_codes.select { |code| code.usable_by?(current_user) }

    render json: {
      success: true,
      discount_codes: available_codes.map do |code|
        {
          code: code.code,
          discount_type: code.discount_type,
          value: code.value,
          description: get_discount_description(code),
          expires_at: code.expires_at&.iso8601,
          user_specific: code.user_id.present?
        }
      end
    }
  end

  private

  def get_invalid_reason(discount_code)
    return "El código de descuento está inactivo" unless discount_code.active?
    return "El código de descuento ha expirado" if discount_code.expired?
    return "Este código de descuento es exclusivo para otro usuario" if discount_code.user.present? && discount_code.user != current_user
    return "El código de descuento ha alcanzado su límite total de usos" if discount_code.max_uses && discount_code.discount_usages.count >= discount_code.max_uses
    return "Ya has alcanzado el límite de usos para este código" if discount_code.max_uses_per_user && discount_code.discount_usages.where(user: current_user).count >= discount_code.max_uses_per_user
    
    "El código de descuento no es válido"
  end

  def get_discount_description(discount_code)
    if discount_code.percentage?
      "#{discount_code.value}% de descuento"
    else
      "$#{discount_code.value} de descuento"
    end
  end

  def get_remaining_uses(discount_code)
    if discount_code.max_uses.present?
      remaining = discount_code.max_uses - discount_code.discount_usages.count
      [0, remaining].max
    else
      nil # Sin límite
    end
  end
end