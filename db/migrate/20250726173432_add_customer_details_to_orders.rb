class AddCustomerDetailsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :email, :string
    add_column :orders, :address, :text
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :postal_code, :string
    add_column :orders, :country, :string

     # add_index :orders, :email
    # add_index :orders, [:first_name, :last_name]

  end
end
