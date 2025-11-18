class MostPopularController < ApplicationController
  def index
    @categories = Category.all

    year = params[:year] || Date.today.year.to_s

    # Hash para acumular ventas por producto
    product_popularity = Hash.new(0)

    # Recorremos cada mes para contar ventas
    (1..12).each do |month|
      month_str = month.to_s.rjust(2, '0')

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

    # Ordenamos y tomamos los top 20
    top_product_ids = product_popularity.sort_by { |_id, count| -count }.map(&:first).take(20)

    # Obtenemos los productos manteniendo el orden
    @products = Product.where(id: top_product_ids)
                       .with_attached_images
                       .sort_by { |p| top_product_ids.index(p.id) }
  end
end
