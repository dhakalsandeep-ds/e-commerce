require "test_helper"

class Dashboard::LandingPageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_landing_page_index_url
    assert_response :success
  end
end
