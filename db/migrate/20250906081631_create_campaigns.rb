class CreateCampaigns < ActiveRecord::Migration[8.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.text :description
      t.string :campaign_type
      t.date :start_date
      t.date :end_date
      t.decimal :budget
      t.boolean :active

      t.timestamps
    end
  end
end
