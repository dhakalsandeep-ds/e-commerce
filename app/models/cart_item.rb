class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product 
  belongs_to :variant, optional: true

  # Return a variant, or fallback to the first variant of the product
  def variant
    super || product.variants.first
  end

  def price
    variant&.price || 0
  end

  def subtotal
    price * quantity
  end

  def image
    variant&.image || product.image
  end

  def option_values_text
    variant&.option_values&.pluck(:name)&.join(', ')
  end
end
