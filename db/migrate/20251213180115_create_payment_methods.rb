class CreatePaymentMethods < ActiveRecord::Migration[8.0]
  def change
    create_table :payment_methods do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stripe_payment_method_id
      t.string :brand
      t.string :last4
      t.integer :exp_month
      t.integer :exp_year
      t.boolean :is_default
      t.string :fingerprint

      t.timestamps
    end
  end
end
