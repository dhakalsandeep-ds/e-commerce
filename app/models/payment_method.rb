# app/models/payment_method.rb
class PaymentMethod < ApplicationRecord
  belongs_to :user
  
  validates :stripe_payment_method_id, presence: true, uniqueness: true
  validates :brand, :last4, :exp_month, :exp_year, presence: true
  
  scope :default, -> { where(is_default: true) }
  scope :active, -> { where('exp_year > ? OR (exp_year = ? AND exp_month >= ?)', 
                           Date.current.year, 
                           Date.current.year, 
                           Date.current.month) }
  
  def display_brand
    case brand.downcase
    when 'visa', 'mastercard', 'amex', 'discover'
      brand.capitalize
    else
      'Card'
    end
  end
  
  def display_number
    "**** **** **** #{last4}"
  end
  
  def display_expiry
    "#{exp_month.to_s.rjust(2, '0')}/#{exp_year}"
  end
  
  def expired?
    exp_year < Date.current.year || (exp_year == Date.current.year && exp_month < Date.current.month)
  end
  
  def mark_as_default!
    transaction do
      user.payment_methods.update_all(is_default: false)
      update!(is_default: true)
    end
  end
end