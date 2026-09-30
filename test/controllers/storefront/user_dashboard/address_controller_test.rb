require "test_helper"

class Storefront::UserDashboard::AddressControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get storefront_user_dashboard_address_show_url
    assert_response :success
  end

  test "should get edit" do
    get storefront_user_dashboard_address_edit_url
    assert_response :success
  end

  test "should get update" do
    get storefront_user_dashboard_address_update_url
    assert_response :success
  end
end
