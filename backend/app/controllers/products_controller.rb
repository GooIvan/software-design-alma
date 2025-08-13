class ProductsController < ApplicationController
  before_action :set_category

  def index
    @categories = Category.all
    @products = @category.products
  end
  
  def show
    @product = @category.products.find(params[:id])
  end

  private

  def set_category
  @category = Category.find_by(slug: params[:category_slug] || params[:category_id])
   unless @category
    redirect_to root_path, alert: "La categoría no existe."
   end
  end

end
