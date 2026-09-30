class AddSizeAndColorToOrderItems < ActiveRecord::Migration[8.0]
  def change
    add_column :order_items, :size, :string
    add_column :order_items, :color, :string
  end
end
