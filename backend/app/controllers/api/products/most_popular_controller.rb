module Api
  module Products
    class MostPopularController < ApplicationController
      include Rails.application.routes.url_helpers

      def index
        year = params[:year] || Date.today.year.to_s

        # Creamos un hash con la popularidad por producto
        product_popularity = Hash.new(0)

        # Recorremos cada mes como en tu medidor
        (1..12).each do |month|
          month_str = month.to_s.rjust(2, '0')

          # Buscamos todos los productos vendidos en ese mes
          OrderItem
            .joins(:order)
            .where(orders: { status: "paid" })
            .where("strftime('%Y', orders.created_at) = ? AND strftime('%m', orders.created_at) = ?", year, month_str)
            .group(:product_id)
            .count
            .each do |product_id, count|
              product_popularity[product_id] += count
            end
        end

        # Ordenamos de mayor a menor popularidad y tomamos los top 10
        top_product_ids = product_popularity.sort_by { |_id, count| -count }.map(&:first).take(10)

        # Traemos los productos en ese orden
        products = Product.where(id: top_product_ids).with_attached_image
        products = products.sort_by { |p| top_product_ids.index(p.id) }

        render json: products.map { |product| serialize_product(product, product_popularity[product.id]) }
      end

      private

      def serialize_product(product, popularity_score)
        {
          id: product.id,
          name: product.name,
          price: product.price,
          formatted_price: product.formatted_price,
          sizes: product.sizes,
          stock: product.stock,
          category_id: product.category_id,
          category_name: product.category.name,
          popularity: popularity_score, # Medidor basado en tus criterios
          image_url: product.image.attached? ? url_for(product.image) : nil
        }
      end
    end
  end
end
