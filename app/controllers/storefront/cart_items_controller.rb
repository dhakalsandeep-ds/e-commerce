class Storefront::CartItemsController < ApplicationController
 before_action :set_cart # Use your helper method to get the current cart

#   def create
#     product = Product.find(params[:product_id])
#   quantity = [params[:quantity].to_i, 1].max # at least 1

#   size = params[:size]
#   color = params[:color]

#   @cart.add_product(product.id, quantity, size, color)

#   # ✅ NEW: Check if this is a "Buy now" request
#   if params[:redirect_to_checkout] == "true"
#     redirect_to checkout_show_path, notice: 'Proceeding to checkout...'
#   else
#     redirect_to cart_path, notice: 'Product added to cart!'
#   end
# rescue ActiveRecord::RecordNotFound
#   redirect_to products_path, alert: 'Product not found.'
# end  

def create
  product = Product.find(params[:product_id])
  variant_id = params[:variant_id].presence
  quantity = [params[:quantity].to_i, 1].max

   if current_user
  UserInteraction.create!(
    user: current_user,
    product: product,
    interaction_type: 'add_to_cart',
    score: 2.0
  )
end



  # Validate variant belongs to product
  if variant_id && !product.variants.exists?(variant_id)
    raise ActiveRecord::RecordNotFound
  end

  @cart.add_product(product.id, quantity, variant_id: variant_id)

  if params[:redirect_to_checkout] == "true"
    redirect_to checkout_show_path, notice: "Proceeding to checkout..."
  else
    redirect_to cart_path, notice: "Product added to cart!"
  end
rescue ActiveRecord::RecordNotFound
  redirect_to products_path, alert: "Product or variant not found."
end


  def update
    cart_item = @cart.cart_items.find(params[:id])
    new_quantity = params[:quantity].to_i

    if new_quantity <= 0
      cart_item.destroy
      redirect_to cart_path, notice: 'Item removed from cart.'
    else
      cart_item.update(quantity: new_quantity)
      redirect_to cart_path, notice: 'Cart updated.'
    end
  rescue ActiveRecord::RecordNotFound
     redirect_to cart_path, alert: 'Item not found in cart.'
  end

  def destroy
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: 'Item removed from cart.'
  rescue ActiveRecord::RecordNotFound
     redirect_to cart_path, alert: 'Item not found in cart.'
  end

  private

  def set_cart
    # This relies on the `current_cart` helper method you defined earlier
    # Ensure Storefront::CartHelper is included in your controller or ApplicationContoller
    @cart = current_cart
  end

end
