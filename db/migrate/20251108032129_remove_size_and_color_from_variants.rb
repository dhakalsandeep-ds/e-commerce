class RemoveSizeAndColorFromVariants < ActiveRecord::Migration[8.0]
  def change
    remove_column :variants, :size, :string
    remove_column :variants, :color, :string
  end
end
