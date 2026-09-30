class AddCompareAtPriceToVariants < ActiveRecord::Migration[8.0]
  def change
    add_column :variants, :compare_at_price, :decimal, precision: 10, scale: 2
  end
end
