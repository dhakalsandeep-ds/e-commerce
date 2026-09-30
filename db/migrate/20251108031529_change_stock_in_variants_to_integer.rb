class ChangeStockInVariantsToInteger < ActiveRecord::Migration[8.0]
  def change
     reversible do |dir|
      dir.up do
        # Convert valid numeric strings to integers, others to 0
        Variant.reset_column_information
        Variant.find_each do |variant|
          begin
            stock_val = variant.stock.to_s.strip
            new_stock = if stock_val.match?(/\A-?\d+\z/) # Only integers
                          [stock_val.to_i, 0].max # Ensure >= 0
                        else
                          0
                        end
            variant.update_column(:stock, new_stock)
          rescue
            variant.update_column(:stock, 0)
          end
        end
      end
    end

    # Change column type to integer
    change_column :variants, :stock, :integer, default: 0, null: false
  end

    def down
    change_column :variants, :stock, :string
  end

end
