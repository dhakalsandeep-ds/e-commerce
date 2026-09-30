class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  # Status enum
  enum :status, {
    pending: "pending",
    processing: "processing",
    shipped: "shipped",
    delivered: "delivered",
    cancelled: "cancelled"
  }, prefix: :status

  # Payment status enum
  enum :payment_status, {
    pending: "pending",
    processing: "processing",
    authorized: "authorized",
    paid: "paid",
    failed: "failed",
    refunded: "refunded",
    partially_refunded: "partially_refunded"
  }, prefix: :payment

  # Payment method enum
  enum :payment_method, {
    cod: "cod",
    stripe: "stripe",
    card: "card",
    paypal: "paypal",
    bank_transfer: "bank_transfer"
  }

  # Email validation
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            allow_blank: true

  # Pricing methods
  def min_variant_price
    variants.minimum(:price)
  end

  def subtotal
    order_items.sum do |item|
      item.price.to_f * item.quantity.to_i
    end
  end

  def shipping_cost
    read_attribute(:shipping_cost).to_f
  end

  def tax
    read_attribute(:tax).to_f
  end

  def total_price
    subtotal + shipping_cost + tax
  end

  # Fulfill order after successful Stripe Checkout
  def fulfill_from_stripe_session!(session)
    shipping = session&.shipping_details
    customer_email = session&.customer_details&.email

    update!(
      first_name: (shipping&.name&.split&.first || "N/A"),
      last_name: (shipping&.name&.split&.last || "N/A"),
      address: shipping&.address&.line1,
      city: shipping&.address&.city,
      state: shipping&.address&.state,
      postal_code: shipping&.address&.postal_code,
      country: shipping&.address&.country,

      email: customer_email || user&.email || "unknown@example.com",

      # Stripe payment information
      stripe_payment_intent_id: session.payment_intent,

      payment_status: "paid",
      paid_at: Time.current,
      status: "processing"
    )
  end

  # Convenience method
  def paid?
    payment_paid? && paid_at.present?
  end
end
