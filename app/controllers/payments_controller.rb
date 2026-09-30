class PaymentsController < ApplicationController 
 require 'openssl'
  require 'base64'

  SECRET_KEY = '8gBm/:&EnhH.1/q('  # eSewa test secret key

  def index
    @amount = 100
    @tax_amount = 0
    @product_service_charge = 0
    @product_delivery_charge = 0

    @total_amount = @amount + @tax_amount + @product_service_charge + @product_delivery_charge

    @transaction_uuid = "order-#{Time.now.to_i}"
    @product_code = "EPAYTEST"

    # Fields to sign in order
    @signed_field_names = "total_amount,transaction_uuid,product_code"
    @success_url = "https://developer.esewa.com.np/success"
    @failure_url = "https://developer.esewa.com.np/failure"

    # Data hash for signing
    data_to_sign = {
  "total_amount" => @total_amount.to_s,
  "transaction_uuid" => @transaction_uuid,
  "product_code" => @product_code
}


    @signature = generate_signature(data_to_sign, @signed_field_names)
    puts "Singature: #{@signature}"
  end

private

  def generate_signature(params, signed_field_names)
    data = signed_field_names.split(',').map { |field| "#{field}=#{params[field]}" }.join(',') 
    puts "String to sign: #{data}"
    # puts "Signature: #{signature}"

    digest = OpenSSL::HMAC.digest('sha256', SECRET_KEY, data)
    Base64.strict_encode64(digest)
  end

  

end