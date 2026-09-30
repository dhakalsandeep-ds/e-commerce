class CreateDiscounts < ActiveRecord::Migration[8.0]
  def change
    create_table :discounts do |t|
     t.string :name, null: false
      t.string :code, null: false
      t.string :discount_type, null: false
      t.decimal :value, precision: 10, scale: 2
      t.decimal :minimum_order_amount, precision: 10, scale: 2
      t.integer :usage_limit
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :status, default: 'active'
      t.text :description
      t.boolean :applies_to_shipping, default: false
      
      t.timestamps

    
    end


      add_index :discounts, :code, unique: true
    add_index :discounts, :status
  end
end
