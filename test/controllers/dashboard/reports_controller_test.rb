require "test_helper"

class Dashboard::ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_reports_index_url
    assert_response :success
  end
end
