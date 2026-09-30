class StorefrontController < ApplicationController 

  before_action :assign_current_cart_to_instance_variable

  private

  def assign_current_cart_to_instance_variable
       @cart = current_cart
  end

end