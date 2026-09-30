class AddDeletedToUsers < ActiveRecord::Migration[8.0]
  def change
    # Add the deleted column with a default of false and disallow NULL
    add_column :users, :deleted, :boolean, default: false, null: false
    # Optional: Add an index for faster lookups of non-deleted users
    # add_index :users, :deleted
  end
end
