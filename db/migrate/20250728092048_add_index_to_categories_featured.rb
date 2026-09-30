class AddIndexToCategoriesFeatured < ActiveRecord::Migration[8.0] # Adjust version if needed
  def change
    add_index :categories, :featured
  end
end