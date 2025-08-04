module Api
  class CategoriesController < ApplicationController
    include Rails.application.routes.url_helpers

    def index
      categories = Category.with_attached_image.order(:name)
      render json: categories.map { |category| serialize_category(category) }
    end

    private

    def serialize_category(category)
      {
        id: category.id,
        name: category.name,
        image_url: category.image.attached? ? url_for(category.image) : nil
      }
    end
  end
end
