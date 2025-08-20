module Api
  class ProductsController < ApplicationController
    include Rails.application.routes.url_helpers

    before_action :set_category, only: [:index, :show]

    def index
      products = @category.products.with_attached_image
      render json: products.map { |product| serialize_product(product) }
    end

    def latest
      products = Product.order(created_at: :desc).limit(4).with_attached_image
      render json: products.map { |product| serialize_product(product) }
    end

    def show
      product = @category.products.find(params[:id])
      render json: serialize_product(product)
    end

    private

    def set_category
      normalized_slug = params[:category_slug].strip.downcase.gsub(' ', '-')
      @category = Category.find_by!(slug: normalized_slug)
    end

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
