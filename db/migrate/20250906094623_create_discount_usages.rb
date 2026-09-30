class CreateDiscountUsages < ActiveRecord::Migration[8.0]
  def change
    create_table :discount_usages do |t|


      
      t.references :discount, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :order_amount
      t.decimal :discount_amount

      t.timestamps
    end
  end
end
