class CreateOptionValues < ActiveRecord::Migration[8.0]
   def change
    create_table :option_values do |t|
      t.string :name, null: false
      t.references :option_type, null: false, foreign_key: true
      t.integer :position, default: 0
      t.timestamps
    end

    add_index :option_values, [:option_type_id, :name], unique: true
  end
end
