class ChangeUserIdToNullableInCarts < ActiveRecord::Migration[8.0]
  def change 
    change_column :carts, :user_id, :bigint, null: true
  end 


  def down
    # Revert: Make user_id NOT NULL again (be careful, existing NULLs might cause issues)
    # You might need to handle existing NULL user_ids in the down migration
    # e.g., delete carts with NULL user_id or assign them to a default/guest user
    # change_column :carts, :user_id, :integer, null: false
    raise ActiveRecord::IrreversibleMigration, "Cannot make user_id NOT NULL because existing records might have NULL values."
  end

end
