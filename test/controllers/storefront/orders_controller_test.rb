require "test_helper"

class Storefront::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get storefront_orders_new_url
    assert_response :success
  end

  test "should get create" do
    get storefront_orders_create_url
    assert_response :success
  end

  test "should get show" do
    get storefront_orders_show_url
    assert_response :success
  end
end
