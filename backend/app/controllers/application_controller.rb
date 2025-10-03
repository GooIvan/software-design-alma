class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :load_categories

  # Todo relacionado con el cambio de idioma, por defecto será redirigido a español
  before_action :redirect_to_default_locale, unless: -> { params[:locale].present? || api_request? }
  before_action :set_locale, unless: -> { api_request? }

  helper_method :current_cart

  def redirect_to_default_locale
    redirect_to url_for(locale: I18n.default_locale)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def api_request?
    request.path.starts_with?('/api/')
  end

  def default_url_options
    { host: request.host,
      port: request.port,
      locale: I18n.locale 
    }
  end

  # Todo: Método para permitir parámetros adicionales para Devise (si es un controlador de Devise)
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permitir estos campos en el registro
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :last_name, :phone, :city, :address ])

    # Permitir estos campos en la actualización de cuenta
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :last_name, :phone, :city, :address ])
  end

  # * Método para redirigir al usuario al perfil después de iniciar sesión
  def after_sign_in_path_for(resource)
    profile_path
  end

  def load_categories
    @categories = Category.all
  end

  def current_cart
    if session[:cart_id]
      Cart.includes(cart_items: :product).find_by(id: session[:cart_id]) || create_cart
    else
      create_cart
    end
  end

  def create_cart
    cart = Cart.create
      session[:cart_id] = cart.id
    cart
  end

end
