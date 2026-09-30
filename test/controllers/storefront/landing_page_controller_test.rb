require "test_helper"

class Storefront::LandingPageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get storefront_landing_page_index_url
    assert_response :success
  end
end
