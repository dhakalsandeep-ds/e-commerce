module Storefront::CartsHelper 


    # Finds or creates a cart ID in the session
  def find_or_create_cart_id
    session[:cart_id] ||= Cart.create.id
    session[:cart_id]
  end

  # Retrieves the current cart object (from session or user)
  def current_cart
    # If user is signed in and has a cart, use that
    if user_signed_in? && current_user.cart
      # Optionally merge session cart items into user's cart if needed
      # This example prioritizes the user's persistent cart
      return current_user.cart
    end

    # Otherwise, use the session-based cart
    cart_id = session[:cart_id]
    cart = Cart.find_by(id: cart_id)

    # If no cart exists in session or DB, create a new one
    unless cart
      cart = Cart.create
      session[:cart_id] = cart.id
    end

    cart
  end

  # Adds an item to the current cart
  def add_to_cart(product_id, quantity = 1, size = nil, color = nil)
    cart = current_cart
    cart.add_product(product_id, quantity, size, color)
  end

   # Removes an item from the current cart
  def remove_from_cart(cart_item_id)
    cart = current_cart
    cart.remove_item(cart_item_id)
  end

  # Updates the quantity of an item in the current cart
  def update_cart_item_quantity(cart_item_id, new_quantity)
    cart = current_cart
    cart.update_item_quantity(cart_item_id, new_quantity)
  end

   # Empties the current cart
  def empty_cart
    cart = current_cart
    cart.cart_items.destroy_all
    # Optionally clear the session cart ID if not linking to user
    # session.delete(:cart_id) if !user_signed_in?
  end

end
