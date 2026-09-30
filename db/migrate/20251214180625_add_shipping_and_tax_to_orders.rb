class AddShippingAndTaxToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :shipping_cost, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :tax, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
