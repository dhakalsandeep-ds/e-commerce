class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product 
    belongs_to :variant, optional: true  # This requires variant_id to be nullable


   def subtotal
    quantity * price.to_f # Use 'price' captured at order time
  end

  def display_name
    if variant.present?
      "#{product.name} (#{variant.option_values.pluck(:name).join(', ')})"
    else
      product.name
    end
  end

end
