require "test_helper"

class Storefront::CheckoutControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get storefront_checkout_show_url
    assert_response :success
  end
end
