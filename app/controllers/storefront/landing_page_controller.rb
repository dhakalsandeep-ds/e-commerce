class Storefront::LandingPageController < ApplicationController
  def index
  
    @featured_categories = ::Category.all.limit(4)
   
    @cart = current_cart
    
    @featured_products = ::Product.all.limit(3)
   

  end
end
