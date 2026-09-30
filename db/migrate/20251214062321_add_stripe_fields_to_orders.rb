class AddStripeFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
   add_column :orders, :stripe_session_id, :string
    add_column :orders, :stripe_payment_intent_id, :string
    add_column :orders, :payment_method, :string, default: 'stripe'
    add_column :orders, :payment_status, :string, default: 'pending'
    
    # Remove old payment fields (optional)
    if column_exists?(:orders, :card_number)
      remove_column :orders, :card_number, :string
    end
    
    if column_exists?(:orders, :expiration_date)
      remove_column :orders, :expiration_date, :string
    end
    
    if column_exists?(:orders, :cvc)
      remove_column :orders, :cvc, :string
    end
    
    # Add indexes for better performance
    add_index :orders, :stripe_session_id, unique: true
    add_index :orders, [:user_id, :stripe_payment_intent_id], unique: true
  end
end
