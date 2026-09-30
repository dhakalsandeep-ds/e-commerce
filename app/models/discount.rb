# app/models/discount.rb
class Discount < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :discount_type, presence: true
  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :minimum_order_amount, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :usage_limit, numericality: { greater_than: 0 }, allow_blank: true
  
  # Discount types enum
  enum :discount_type, {
    percentage: 'percentage',
    fixed_amount: 'fixed_amount',
    free_shipping: 'free_shipping'
  }
  
  # Status enum
  enum :status, {
    active: 'active',
    inactive: 'inactive',
    expired: 'expired'
  }, default: :active
  
  # Automatic code generation if not provided
  before_validation :generate_code, unless: :code?
  
  # Track usage
  has_many :discount_usages, dependent: :destroy
  
  def usage_count
    discount_usages.count
  end
  
  def remaining_uses
    return nil unless usage_limit
    usage_limit - usage_count
  end
  
  def expired?
    ends_at && ends_at < Time.current
  end
  
  def started?
    starts_at.nil? || starts_at <= Time.current
  end
  
  def currently_active?
    active? && started? && !expired?
  end
  
  def calculate_discount(amount)
    return 0 unless currently_active?
    return 0 if minimum_order_amount && amount < minimum_order_amount
    
    case discount_type
    when 'percentage'
      [(amount * value / 100), amount].min
    when 'fixed_amount'
      [value, amount].min
    when 'free_shipping'
      0 # This would be handled separately for shipping costs
    else
      0
    end
  end
  
  private
  
  def generate_code
    self.code = "DISCOUNT-#{SecureRandom.hex(4).upcase}" unless code?
  end
end