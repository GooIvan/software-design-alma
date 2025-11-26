class Admin::CategoriesController < ApplicationController
  layout "admin"
  before_action :set_category, only: [ :edit, :update, :destroy ]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: "Categoría creada correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Categoría actualizada correctamente."
    else
      render :edit
    end
  end

  def destroy
    products_count = @category.products.count
    
    begin
      @category.destroy
      
      if products_count > 0
        redirect_to admin_categories_path, notice: "Categoría eliminada correctamente junto con #{products_count} producto(s) asociado(s) y todos sus elementos relacionados."
      else
        redirect_to admin_categories_path, notice: "Categoría eliminada correctamente."
      end
    rescue ActiveRecord::InvalidForeignKey
      redirect_to admin_categories_path, alert: "No se pudo eliminar la categoría debido a restricciones de base de datos. Contacta al administrador del sistema."
    end
  end

  private

  def set_category
    @category = Category.find_by!(slug: params[:slug])
  end

  def category_params
    params.require(:category).permit(:name, :image)
  end
end
