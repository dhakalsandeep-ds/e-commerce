class Storefront::OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    cart = current_cart

    if cart.nil? || cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty!"
      return
    end

    @order = current_user.orders.create!(
      status: "pending",
      payment_status: "pending",
      payment_method: "stripe"
    )

    stripe_session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode: "payment",
      line_items: build_line_items(cart),

      success_url: order_success_url(@order) +
        "?checkout_session_id={CHECKOUT_SESSION_ID}",

      cancel_url: order_cancel_url(@order),

      customer_email: current_user.email,

      shipping_address_collection: {
        allowed_countries: %w[NP US CA GB IN]
      },

      metadata: {
        user_id: current_user.id.to_s,
        cart_id: cart.id.to_s,
        order_id: @order.id.to_s
      }
    )

    @order.update!(
      checkout_session_id: stripe_session.id
    )

    redirect_to stripe_session.url, allow_other_host: true

  rescue => e
    Rails.logger.error "Stripe checkout error:"
    Rails.logger.error e.full_message

    @order&.destroy

    redirect_to cart_path,
                alert: "Unable to start payment."
  end

  def success
    @order = current_user.orders.find(params[:id])

    session_id = params[:checkout_session_id]

    if session_id.blank?
      redirect_to cart_path,
                  alert: "Payment session is missing."
      return
    end

    stripe_session = Stripe::Checkout::Session.retrieve(session_id)

    # Make sure this Stripe session actually belongs
    # to this order and this user.
    unless stripe_session.id == @order.checkout_session_id &&
           stripe_session.metadata["order_id"] == @order.id.to_s &&
           stripe_session.metadata["user_id"] == current_user.id.to_s
      redirect_to cart_path,
                  alert: "Invalid payment session."
      return
    end

    # Stripe Checkout completed, but payment may not
    # necessarily have succeeded.
    unless stripe_session.payment_status == "paid"
      redirect_to cart_path,
                  alert: "Payment was not completed."
      return
    end

    # Prevent refreshing the success URL from creating
    # duplicate order items or reducing stock twice.
    if @order.payment_paid?
      render :success
      return
    end

    cart_id = stripe_session.metadata["cart_id"]

    # IMPORTANT:
    # User does not have a `carts` association in this app.
    # Therefore use Cart directly.
    cart = Cart.find_by(id: cart_id)

    unless cart
      redirect_to cart_path,
                  alert: "Cart could not be found."
      return
    end

    if cart.cart_items.empty?
      redirect_to cart_path,
                  alert: "Cart is empty."
      return
    end

    ActiveRecord::Base.transaction do
      cart.cart_items.each do |item|
        variant = item.variant

        unless variant
          raise "Variant not found for #{item.product.name}"
        end

        if variant.stock < item.quantity
          raise "Not enough stock for #{variant.name}"
        end

        variant.update!(
          stock: variant.stock - item.quantity
        )

        @order.order_items.create!(
          product: item.product,
          variant: variant,
          quantity: item.quantity,
          price: item.price
        )
      end

      @order.fulfill_from_stripe_session!(stripe_session)

      cart.cart_items.destroy_all
    end

    render :success

  rescue => e
    Rails.logger.error "Order success error:"
    Rails.logger.error e.full_message

    redirect_to cart_path,
                alert: "Order confirmation failed."
  end

  def cancel
    @order = current_user.orders.find(params[:id])

    redirect_to cart_path,
                alert: "You cancelled the payment. Your order has not been confirmed."
  rescue ActiveRecord::RecordNotFound
    redirect_to cart_path,
                alert: "Order could not be found."
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  private

  def build_line_items(cart)
    cart.cart_items.map do |item|
      {
        price_data: {
          currency: "usd",

          product_data: {
            name: item.product.name,
            description: item.option_values_text.presence || "No options"
          },

          unit_amount: (item.price.to_f * 100).to_i
        },

        quantity: item.quantity
      }
    end
  end
end
