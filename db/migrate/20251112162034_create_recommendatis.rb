class CreateRecommendatis < ActiveRecord::Migration[8.0]
  def change
    create_table :recommendation_cache do |t|
      t.references :product, null: false, foreign_key: true
      t.references :recommended_product, null: false, foreign_key: { to_table: :products }
      t.float :similarity_score, null: false
      t.string :similarity_method, null: false  # 'jaccard', 'cosine', 'pearson'
      t.integer :interaction_count, default: 0
      t.datetime :calculated_at
      t.datetime :expires_at
      
      t.timestamps
    end
    
    add_index :recommendation_cache, [:product_id, :similarity_method]
    add_index :recommendation_cache, :expires_at
  end
end
