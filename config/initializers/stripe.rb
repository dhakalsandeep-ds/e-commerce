# config/initializers/stripe.rb
Rails.configuration.stripe = {
  # publishable_key: Rails.application.credentials.dig(:stripe, :publishable_key),
  secret_key: Rails.application.credentials.dig(:stripe, :secret_key)
}

Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
Stripe.api_version = '2023-10-16'  # Use latest stable version