class CreateUserInteractions < ActiveRecord::Migration[8.0]
   def change
    create_table :user_interactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :interaction_type, null: false # 'view', 'cart', 'purchase', 'like'
      t.float :score, default: 1.0
      t.datetime :created_at

      t.index [:user_id, :product_id, :interaction_type]
      t.index [:product_id, :interaction_type]
    end
  end
end
