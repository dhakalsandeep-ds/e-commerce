class CreateVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :sku
      t.decimal :price
      t.integer :stock
      t.string :size
      t.string :color

      t.timestamps
    end
  end
end
