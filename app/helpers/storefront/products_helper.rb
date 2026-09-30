module Storefront::ProductsHelper
 
  def display_price(product)
    if product.variants.any?
      product.variants.first.price.to_f
    else
      product.respond_to?(:price) ? product.price.to_f : 0.0
    end
  end

end
