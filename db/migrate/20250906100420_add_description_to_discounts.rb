class AddDescriptionToDiscounts < ActiveRecord::Migration[8.0]
  def change
        add_column :discounts, :description, :text unless column_exists?(:discounts, :description)
  end
end
