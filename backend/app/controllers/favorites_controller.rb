class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_favorite, only: [:destroy]

  def index
    @favorites = current_user.favorites.includes(:product)
    # Precargar las imágenes de los productos
    Product.where(id: @favorites.map(&:product_id)).with_attached_images.load
  end

  def create
    @product = Product.find(params[:product_id])
    @favorite = current_user.favorites.find_or_create_by(product: @product)

    if @favorite.persisted?
      redirect_back fallback_location: category_product_path(@product.category, @product), 
                    notice: "Agregado a favoritos"
    else
      redirect_back fallback_location: category_product_path(@product.category, @product), 
                    alert: "Error al agregar a favoritos: #{@favorite.errors.full_messages.join(', ')}"
    end
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: root_path, alert: "Producto no encontrado"
  end

  def destroy
    @favorite.destroy
    redirect_back fallback_location: favorites_path, notice: "Eliminado de favoritos"
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: favorites_path, alert: "Favorito no encontrado"
  end

  private

  def set_favorite
    @favorite = current_user.favorites.find(params[:id])
  end
end
