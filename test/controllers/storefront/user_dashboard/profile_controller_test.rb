require "test_helper"

class Storefront::UserDashboard::ProfileControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get storefront_user_dashboard_profile_show_url
    assert_response :success
  end

  test "should get edit" do
    get storefront_user_dashboard_profile_edit_url
    assert_response :success
  end

  test "should get update" do
    get storefront_user_dashboard_profile_update_url
    assert_response :success
  end
end
