class CartItemsController < ApplicationController
  def create
    cart = current_cart
    product = Product.find(params[:product_id])

    sizes = Array(params[:sizes].presence || params[:size])
    quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1

    if sizes.empty?
      redirect_back fallback_location: root_path, alert: t("size_obligatory")
      return
    end

    sizes.each do |size|
      item = cart.cart_items.find_by(product_id: product.id, size: size)

      if item
        item.quantity += quantity
      else
        item = cart.cart_items.build(product: product, size: size, quantity: quantity)
      end

      item.save
    end

    flash[:item_added] = true
    redirect_back fallback_location: root_path
  end

  def destroy
    item = current_cart.cart_items.find(params[:id])
    item_id = item.id
    item.destroy
    current_cart.reload

    cart_count = current_cart.cart_items.sum(:quantity)

    respond_to do |format|
      format.turbo_stream do
        streams = []

        streams << turbo_stream.remove("line_item_#{item_id}")
        streams << turbo_stream.replace("cart_count", partial: "shared/cart/cart_count", locals: { cart: current_cart })
        streams << turbo_stream.replace("total_price", partial: "shared/cart/total_price")
        streams << turbo_stream.replace("cart_subtotal", partial: "cart_items/summary", locals: { cart: current_cart })

        streams << turbo_stream.replace("cart_icon_xl", partial: "shared/cart/cart_icon", locals: {
          icon_id: "cart-toggle-xl",
          extra_classes: "d-none d-lg-flex",
          cart_items_count: cart_count
        })

        streams << turbo_stream.replace("cart_icon_mobile", partial: "shared/cart/cart_icon", locals: {
          icon_id: "cart-toggle",
          extra_classes: "d-lg-none",
          cart_items_count: cart_count
        })

        if current_cart.cart_items.empty?
          streams << turbo_stream.replace("side_cart_content", partial: "shared/cart/side_cart_empty_content")
          streams << turbo_stream.replace("total_price", partial: "shared/cart/side_cart_footer_empty")
        end

        render turbo_stream: streams
      end

      format.html { redirect_back fallback_location: root_path }
    end
  end

  def update_quantity
  @cart_item = CartItem.find(params[:id])
  new_quantity = params[:quantity].to_i

  if new_quantity > 0
    @cart_item.update(quantity: new_quantity)
  else
    @cart_item.destroy
  end

  cart = current_cart.reload
  cart_count = cart.cart_items.sum(:quantity)

  respond_to do |format|
    format.turbo_stream do
      streams = []

      # Actualiza el ítem si no se eliminó, si no lo elimina del DOM
      if new_quantity > 0
        streams << turbo_stream.replace("line_item_#{@cart_item.id}", partial: "cart_items/line_item", locals: { item: @cart_item })
        streams << turbo_stream.replace("side_cart_item_#{@cart_item.id}", partial: "cart_items/cart_item", locals: { item: @cart_item })
      else
        streams << turbo_stream.remove("cart_item_#{@cart_item.id}")
        streams << turbo_stream.remove("side_cart_item_#{@cart_item.id}")
      end

      # Actualiza contador de ítems
      streams << turbo_stream.replace("main_cart_count", partial: "shared/cart/cart_count", locals: { cart: current_cart })
      streams << turbo_stream.replace("side_cart_count", partial: "shared/cart/cart_count", locals: { cart: current_cart })

      # Actualiza totales
      streams << turbo_stream.replace("total_price", partial: "shared/cart/total_price")
      streams << turbo_stream.replace("cart_subtotal", partial: "cart_items/summary", locals: { cart: current_cart })

      # Íconos del carrito
      streams << turbo_stream.replace("cart_icon_xl", partial: "shared/cart/cart_icon", locals: {
        icon_id: "cart-toggle-xl",
        extra_classes: "d-none d-lg-flex",  
        cart_items_count: cart_count
      })

      streams << turbo_stream.replace("cart_icon_mobile", partial: "shared/cart/cart_icon", locals: {
        icon_id: "cart-toggle",
        extra_classes: "d-lg-none",
        cart_items_count: cart_count
      })

      # Si el carrito está vacío
      if current_cart.cart_items.empty?
        streams << turbo_stream.replace("side_cart_content", partial: "shared/cart/side_cart_empty_content")
        streams << turbo_stream.replace("total_price", partial: "shared/cart/side_cart_footer_empty")
      end

      render turbo_stream: streams
    end

    format.html { redirect_to cart_path }
    end
  end


  def show
    @cart = current_cart
    @items = @cart.cart_items.includes(:product)
  end

  def count
  target = params[:target] || "main_cart_count"

  render turbo_stream: turbo_stream.replace(
    target,
    partial: "shared/cart/cart_count",
    locals: { cart: current_cart }
  )
  end


end