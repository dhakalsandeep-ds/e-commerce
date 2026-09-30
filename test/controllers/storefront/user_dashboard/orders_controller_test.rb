require "test_helper"

class Storefront::UserDashboard::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get storefront_user_dashboard_orders_index_url
    assert_response :success
  end

  test "should get show" do
    get storefront_user_dashboard_orders_show_url
    assert_response :success
  end
end
