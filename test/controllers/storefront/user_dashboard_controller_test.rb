require "test_helper"

class Storefront::UserDashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get storefront_user_dashboard_show_url
    assert_response :success
  end
end
