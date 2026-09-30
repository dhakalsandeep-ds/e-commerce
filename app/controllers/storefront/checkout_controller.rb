class Storefront::CheckoutController < ApplicationController
  def show
    @cart = current_cart
    redirect_to cart_path, alert: 'Your cart is empty!' if @cart.cart_items.empty?
    
    # Preload cart items for display
    @cart_items = @cart.cart_items.map do |item|
      {
        id: item.id,
        product: item.product,
        variant: item.variant,
        quantity: item.quantity,
        price: item.price,
        subtotal: item.subtotal,
        image: item.image,
        option_values_text: item.option_values_text
      }
    end
  end
end