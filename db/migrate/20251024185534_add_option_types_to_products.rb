class AddOptionTypesToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :option_types, :text
  end
end
