class Cart < ApplicationRecord
   belongs_to :user, optional: true # Cart might belong to a user or be for a guest
  has_many :cart_items, dependent: :destroy 
  belongs_to :variant, optional: true

  # Calculates the total price of items in the cart
  def total_price
    cart_items.sum(&:subtotal)
  end

  # Calculates the total number of items in the cart
  def total_items
    cart_items.sum(:quantity)
  end




  def add_product(product_id, quantity = 1, variant_id: nil)
  current_item = cart_items.find_by(product_id: product_id, variant_id: variant_id)
  if current_item
    current_item.quantity += quantity
    current_item.save
  else
    current_item = cart_items.build(product_id: product_id, quantity: quantity, variant_id: variant_id)
    current_item.save
  end
  current_item
end


def remove_item(cart_item_id)
    cart_items.find_by(id: cart_item_id)&.destroy
  end

  def update_item_quantity(cart_item_id, new_quantity)
    item = cart_items.find_by(id: cart_item_id)
    if item
      if new_quantity <= 0
        item.destroy
      else
        item.update(quantity: new_quantity)
      end
    end
    item
  end


  # Adds a product to the cart or updates its quantity if it already exists
  # def add_product(product_id, quantity = 1, size = nil, color = nil)
  #   current_item = cart_items.find_by(product_id: product_id, size: size, color: color)
  #   if current_item
  #     current_item.quantity += quantity
  #     current_item.save
  #   else
  #     current_item = cart_items.build(product_id: product_id, quantity: quantity, size: size, color: color)
  #     current_item.save
  #   end
  #   current_item
  # end

  # Removes an item from the cart
  def remove_item(cart_item_id)
    cart_items.find_by(id: cart_item_id)&.destroy
  end

   # Updates the quantity of an item in the cart
  def update_item_quantity(cart_item_id, new_quantity)
    item = cart_items.find_by(id: cart_item_id)
    if item
      if new_quantity <= 0
        item.destroy
      else
        item.update(quantity: new_quantity)
      end
    end
    item
  end
end
