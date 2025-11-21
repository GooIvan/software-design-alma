module Api
  class FavoritesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_favorite, only: [:destroy]

    def index
      @favorites = current_user.favorites
        .includes(product: { images_attachments: :blob, category: {} })

      render json: {
        status: "success",
        data: @favorites.map do |fav|
          product = fav.product

          {
            id: fav.id,
            created_at: fav.created_at,

            product: {
              id: product.id,
              name: product.name,
              price: product.price,
              description: product.description,
              category_id: product.category_id,
              formatted_price: product.formatted_price,

              # Generar URLs sin tocar el modelo
              images: product.images.map { |img| url_for(img) },

              category: {
                id: product.category.id,
                name: product.category.name,
                slug: product.category.slug
              }
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
