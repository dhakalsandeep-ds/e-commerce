class DiscountUsage < ApplicationRecord
  belongs_to :discount
  belongs_to :order, optional: true
  belongs_to :user, optional: true 

   validates :order_amount, presence: true, numericality: { greater_than: 0 }
  validates :discount_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  scope :successful, -> { where.not(discount_amount: 0) }

end
