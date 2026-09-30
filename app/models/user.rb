# app/models/user.rb
class User < ApplicationRecord
  # --- Authentication & Authorization ---
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # :trackable, :confirmable, :lockable, :timeoutable, :omniauthable

  has_one_attached :avatar
  enum :role, { customer: 0, admin: 1 }

  # --- Associations ---
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  
  # Add payment methods association
  has_many :payment_methods, dependent: :destroy
  
  # --- Validations ---
  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  
  validates :password, format: {
    with: /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,128}\z/,
    message: "must be between 8 and 128 characters long, include upper and lower case letters, a number, and a special character"
  }, if: :password_required?

  # --- Callbacks ---
  after_create :ensure_cart_exists


  # --- Methods ---
  def full_name
    [first_name, last_name].join(' ')
  end

  def initials
    [first_name, last_name].map { |name| name&.first || '' }.join('').upcase
  end

  def avatar_url
    if avatar.attached?
      avatar.url
    else
      "https://placehold.co/100x100?text=#{initials}"
    end
  end

  def address
    address_line1
  end

  def address=(value)
    self.address_line1 = value
  end

  # --- Stripe Payment Methods ---
  
 
  
  
  
  
  
  def can_make_payment?
    stripe_customer_id.present?
  end
  
  def billing_address
    # Return formatted billing address if you have separate billing address fields
    {
      line1: billing_address_line1,
      line2: billing_address_line2,
      city: billing_city,
      state: billing_state,
      postal_code: billing_postal_code,
      country: billing_country
    }.compact_blank
  end
  
  private
  
  def ensure_cart_exists
    Cart.create(user: self) unless cart
  end
  
  def address_hash
    return nil unless address_line1.present?
    
    {
      line1: address_line1,
      line2: address_line2,
      city: city,
      state: state,
      postal_code: postal_code,
      country: country
    }.compact_blank
  end
  
  def shipping_hash
    return nil unless address_line1.present?
    
    {
      name: full_name,
      phone: phone_number,
      address: address_hash
    }.compact_blank
  end
end