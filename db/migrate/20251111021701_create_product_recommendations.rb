class CreateProductRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :product_recommendations do |t|
       t.references :product, null: false, foreign_key: true
      t.references :recommended_product, null: false, foreign_key: { to_table: :products }
      t.decimal :score, precision: 10, scale: 2, default: 0.0
      t.decimal :support, precision: 10, scale: 6, default: 0.0
      t.decimal :confidence, precision: 10, scale: 6, default: 0.0

      t.index [:product_id, :recommended_product_id], unique: true
     

      t.timestamps
    end
  end
end
