class Admin::ProductsController < ApplicationController
  layout "admin"
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]
  before_action :set_category


  def index
    @products = @category.products.includes(:category).order(created_at: :desc)
  end

  def show
  end

  def new
    @category = Category.find_by!(slug: params[:category_id] || params[:category_slug])
    @product = @category.products.build
  end

  def create
    @category = Category.find_by!(slug: params[:category_id] || params[:category_slug])
    @product = @category.products.build(product_params)
    if @product.save
      redirect_to admin_category_products_path(@category), notice: "Producto creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

def update
  Rails.logger.info "=== INICIANDO UPDATE DE PRODUCTO ==="
  Rails.logger.info "Product ID: #{@product.id}"
  Rails.logger.info "Parámetros completos: #{params.inspect}"
  Rails.logger.info "Parámetros del producto: #{params[:product].inspect}" if params[:product]
  
  # Verificar específicamente remove_images
  Rails.logger.info "¿Existe remove_images en params[:product]? #{params[:product] && params[:product].key?(:remove_images)}"
  Rails.logger.info "Valor de remove_images: #{params[:product][:remove_images].inspect}" if params[:product] && params[:product].key?(:remove_images)
  
  # Buscar remove_images en cualquier lugar de params
  remove_images_found = params.to_unsafe_h.dig('product', 'remove_images')
  Rails.logger.info "remove_images encontrado: #{remove_images_found.inspect}"
  
  # Mostrar todas las keys que contienen 'remove'
  all_params = params.to_unsafe_h
  remove_keys = all_params.select { |k, v| k.to_s.include?('remove') }
  Rails.logger.info "Todas las keys que contienen 'remove': #{remove_keys.inspect}"

  # 1. Eliminar imágenes existentes si se enviaron
  if params[:product] && params[:product][:remove_images].present?
    Rails.logger.info "Imágenes a eliminar: #{params[:product][:remove_images]}"
    
    params[:product][:remove_images].each do |id|
      Rails.logger.info "Procesando eliminación de imagen ID: #{id}"
      image_to_remove = @product.images.find_by(id: id)

      if image_to_remove
        Rails.logger.info "Eliminando imagen #{id}"
        image_to_remove.purge
      else
        Rails.logger.warn "No se encontró imagen con ID #{id}"
      end
    end
  else
    Rails.logger.info "No hay imágenes para eliminar"
  end

  # 2. Separar imágenes nuevas
  new_images = params[:product][:images]
  update_params = product_params.except(:images, :remove_images)

  # 3. Actualizar datos del producto
  if @product.update(update_params)
    # 4. Adjuntar nuevas imágenes
    if new_images.present? && new_images.any?
      @product.images.attach(new_images.compact)
    end

    redirect_to admin_category_products_path(@category), notice: "Producto actualizado exitosamente."
  else
    render :edit, status: :unprocessable_entity
  end
end


  def destroy
    @product = Product.find(params[:id])

    if CartItem.where(product_id: @product.id).any?
      redirect_to admin_category_products_path, alert: "Este producto está en carritos y no puede ser eliminado."
    else
      @product.destroy
      redirect_to admin_category_products_path, notice: "Producto eliminado."
    end
  end


  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_category
    @category = Category.find_by!(slug: params[:category_id] || params[:category_slug])
    redirect_to admin_categories_path, alert: "Categoría no encontrada" unless @category
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :category_id, sizes: [], images: [], remove_images: [])
  end
end
