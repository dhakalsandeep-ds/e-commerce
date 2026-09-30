class AddCustomerGroupToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :customer_group, :string
  end
end
