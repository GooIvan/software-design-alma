module Api
  class FavoritesController < Api::BaseController
    before_action :set_favorite, only: [:destroy]

    # GET /api/favorites
    def index
      @favorites = current_user.favorites
        .includes(product: { images_attachments: :blob, category: {} })

      render json: {
        status: "success",
        data: @favorites.map do |fav|
          product = fav.product

          {
            id: fav.id,
            user_id: fav.user_id,
            created_at: fav.created_at,

            product: {
              id: product.id,
              name: product.name,
              price: product.price,
              description: product.description,
              category_id: product.category_id,
              category_name: product.category.name,
              formatted_price: product.formatted_price,
              sizes: product.sizes,
              stock: product.stock,

              # Generar URLs sin tocar el modelo
              images: product.images.map { |img| url_for(img) }
            }
          }
        end
      }
    end

    # POST /api/favorites
    def create
      product = Product.find(params[:product_id])
      favorite = current_user.favorites.find_or_create_by(product: product)

      if favorite.persisted?
        render json: { 
          status: "success", 
          message: "Agregado a favoritos",
          data: {
            id: favorite.id,
            user_id: favorite.user_id,
            created_at: favorite.created_at,
            product: {
              id: product.id,
              name: product.name,
              price: product.price,
              description: product.description,
              category_id: product.category_id,
              category_name: product.category.name,
              formatted_price: product.formatted_price,
              sizes: product.sizes,
              stock: product.stock,
              images: product.images.map { |img| url_for(img) }
            }
          }
        }, status: :created
      else
        render json: { 
          status: "error", 
          message: "Error al agregar a favoritos",
          errors: favorite.errors.full_messages 
        }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: {
        status: "error",
        message: "Producto no encontrado"
      }, status: :not_found
    end

    # DELETE /api/favorites/:id
    def destroy
      @favorite.destroy
      render json: { 
        status: "success", 
        message: "Eliminado de favoritos" 
      }
    rescue ActiveRecord::RecordNotFound
      render json: {
        status: "error",
        message: "Favorito no encontrado"
      }, status: :not_found
    end

    private

    def set_favorite
      @favorite = current_user.favorites.find(params[:id])
    end
  end 
end
