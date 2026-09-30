class Storefront::CartsController < ApplicationController
  def show
    @cart = current_cart

      cart_product_ids = @cart.cart_items.pluck(:product_id)
  #  if cart_product_ids.any?
  #   min_confidence = Rails.env.development? ? 0.0 : 0.5
    
  #   @cart_recommendations = ProductRecommendation
  #     .where(product_id: cart_product_ids)
  #     .where('confidence >= ?', min_confidence)
  #     .group(:recommended_product_id)
  #     .sum(:confidence)
  #     .sort_by { |_, confidence| -confidence }
  #     .first(3)
  #     .map(&:first)
  #     .compact
    
  #   # Fallback to popular products if no recommendations
  #   if @cart_recommendations.empty?
  #     @cart_recommendations = OrderItem
  #       .joins(:product)
  #       .where.not(product_id: cart_product_ids)
  #       .group('products.id')
  #       .order('COUNT(order_items.id) DESC')
  #       .limit(3)
  #       .pluck(:product_id)
  #   end
  # else
  #   @cart_recommendations = []
  # end
  
  end

  def update
  end

  def destroy
     @cart = current_cart
    @cart.cart_items.destroy_all
    # Optional: session.delete(:cart_id) # Clear session link
    redirect_to cart_path, notice: 'Cart emptied.'
  end
end
