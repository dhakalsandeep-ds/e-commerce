class AddPaymentAndTermsFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :card_number, :string
    add_column :orders, :expiration_date, :string
    add_column :orders, :cvc, :string
    add_column :orders, :agree_to_terms, :boolean
  end
end
