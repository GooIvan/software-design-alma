def show
    @category = Category.find(params[:id])
    @products = @category.products.page(params[:page]).per(2)
end
