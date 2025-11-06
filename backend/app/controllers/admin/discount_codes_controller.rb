class Admin::DiscountCodesController < ApplicationController
  layout "admin"

  before_action :authenticate_user!
  
  def validate
    code = params[:code]&.strip&.upcase
    
    if code.blank?
      render json: { valid: false, message: "El código no puede estar vacío" }
      return
    end

    discount_code = DiscountCode.find_by(code: code)
    
    if discount_code.nil?
      render json: { valid: false, message: "Código de descuento no encontrado" }
      return
    end

    unless discount_code.active?
      render json: { valid: false, message: "Este código de descuento no está activo" }
      return
    end

    if discount_code.expired?
      render json: { valid: false, message: "Este código de descuento ha expirado" }
      return
    end

    if discount_code.max_uses && discount_code.discount_usages.count >= discount_code.max_uses
      render json: { valid: false, message: "Este código de descuento ha alcanzado su límite de usos" }
      return
    end

    # Código válido
    render json: { 
      valid: true, 
      discount_code: {
        id: discount_code.id,
        code: discount_code.code,
        discount_type: discount_code.discount_type,
        value: discount_code.value
      }
    }
  end

  def index
    @discount_codes = DiscountCode.includes(:discount_usages).order(created_at: :desc)
  end

  def new
    @discount_code = DiscountCode.new
  end

  def create
    @discount_code = DiscountCode.new(discount_code_params)
    @discount_code.created_by = current_user

    if @discount_code.save
      redirect_to admin_discount_codes_path, notice: 'Código de descuento creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @discount_code = DiscountCode.find(params[:id])
  end

  def update
    @discount_code = DiscountCode.find(params[:id])
    
    if @discount_code.update(discount_code_params)
      redirect_to admin_discount_codes_path, notice: 'Código de descuento actualizado exitosamente.'
    else
      render :edit
    end
  end

  def destroy
    @discount_code = DiscountCode.find(params[:id])
    @discount_code.destroy
    redirect_to admin_discount_codes_path, notice: 'Código de descuento eliminado exitosamente.'
  end

  private

  def discount_code_params
    permitted_params = params.require(:discount_code).permit(
      :code, :discount_type, :value, :active,
      :expires_at, :max_uses, :max_uses_per_user, :user_id
    )
    
    # Convertir strings vacíos a nil para campos opcionales
    permitted_params[:user_id] = nil if permitted_params[:user_id].blank?
    permitted_params[:max_uses] = nil if permitted_params[:max_uses].blank?
    permitted_params[:max_uses_per_user] = nil if permitted_params[:max_uses_per_user].blank?
    permitted_params[:expires_at] = nil if permitted_params[:expires_at].blank?
    
    permitted_params
  end
end