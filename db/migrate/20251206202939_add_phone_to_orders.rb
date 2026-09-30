class AddPhoneToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :phone, :string
  end
end
