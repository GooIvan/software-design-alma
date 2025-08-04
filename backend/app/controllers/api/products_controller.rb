module Api
  class ProductsController < ApplicationController
    include Rails.application.routes.url_helpers

    def index
      products = Product.order(created_at: :desc).with_attached_image
      render json: products.map { |product| serialize_product(product) }
    end

    def latest
      products = Product.order(created_at: :desc).limit(4).with_attached_image
      render json: products.map { |product| serialize_product(product) }
    end

    def show
      product = Product.find(params[:id])
      render json: serialize_product(product)
    end

    private

    def serialize_product(product)
      {
        id: product.id,
        name: product.name,
        price: product.price,
        formatted_price: product.formatted_price,
        sizes: product.sizes,
        stock: product.stock,
        category_id: product.category_id,
        category_name: product.category.name,
        image_url: product.image.attached? ? url_for(product.image) : nil
      }
    end
  end
end
