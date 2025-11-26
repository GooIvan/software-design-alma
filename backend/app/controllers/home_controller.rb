class HomeController < ApplicationController
  def index
    @home_video = HomeVideo.first_or_initialize
    @categories = Category.all
    @latest_products = Product.order(created_at: :desc).limit(8)
    @featured_products = Product.where("stock > ?", 0).order(created_at: :desc).limit(4)
    # Puedes agregar lógica para productos más vendidos cuando tengas ese campo
    @popular_products = Product.joins(:order_items)
                                .group('products.id')
                                .order('COUNT(order_items.id) DESC')
                                .limit(4)
                                .distinct
  rescue
    # Fallback si no hay order_items aún
    @popular_products = Product.where("stock > ?", 0).limit(4)
  end
end
