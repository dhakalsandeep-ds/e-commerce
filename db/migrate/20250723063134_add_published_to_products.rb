class AddPublishedToProducts < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:products, :published)
      add_column :products, :published, :boolean
    end
  end
end
