module Api
  class FavoritesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_favorite, only: [:destroy]

    # GET /api/favorites
    def index
      favorites = current_user.favorites.includes(product: [:images, :category])
      
      render json: {
        status: "success",
        data: favorites.as_json(
          include: { 
            product: { 
              only: [:id, :name, :price, :description, :category_id], 
              methods: [:formatted_price, :image_urls],
              include: {
                category: { only: [:id, :name, :slug] }
              }
            } 
          },
          only: [:id, :created_at]
        )
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
          data: favorite.as_json(
            include: { 
              product: { 
                only: [:id, :name, :price, :description], 
                methods: [:formatted_price, :image_urls] 
              } 
            }
          )
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
