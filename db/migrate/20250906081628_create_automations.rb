class CreateAutomations < ActiveRecord::Migration[8.0]
  def change
    create_table :automations do |t|
      t.string :name
      t.text :description
      t.string :trigger_type
      t.string :action_type
      t.boolean :active
      t.string :schedule

      t.timestamps
    end
  end
end
