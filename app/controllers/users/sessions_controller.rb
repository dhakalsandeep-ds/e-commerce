class Users::SessionsController < Devise::SessionsController
  layout "authentication"
  protected

  # This runs AFTER user signs in
  def after_sign_in_path_for(resource)
    # 🔥 MERGE GUEST CART HERE
    if session[:cart_id].present?
      guest_cart = Cart.find_by(id: session[:cart_id])
      # Only merge if it's a guest cart (no user assigned)
      if guest_cart&.user_id.nil?
        guest_cart.update!(user: resource) # ← Link cart to logged-in user
      end
    end

    # Then redirect to normal path
    if resource.admin?
      dashboard_root_path
    else
      user_dashboard_path
    end
  end
end
