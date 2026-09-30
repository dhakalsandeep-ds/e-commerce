class CreateCollections < ActiveRecord::Migration[8.0]
  def change
    drop_table :collections, if_exists: true

    create_table :collections do |t|
      t.string :name
      t.text :description
      t.string :handle

      t.timestamps
    end
  end
end
