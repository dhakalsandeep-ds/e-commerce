class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  helper Storefront::CartsHelper

  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      dashboard_root_path
    else
      user_dashboard_path
    end
  end

  private

  def current_cart
    return @current_cart if @current_cart

    if session[:cart_id].present?
      @current_cart = Cart.find_by(id: session[:cart_id])

      if @current_cart && @current_cart.user_id.nil? && current_user
        @current_cart.update!(user: current_user)
      end
    end

    if @current_cart.nil?
      @current_cart = Cart.create!(user: current_user)
      session[:cart_id] = @current_cart.id
    end

    @current_cart
  end
end
