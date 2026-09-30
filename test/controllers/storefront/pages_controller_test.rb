require "test_helper"

class Storefront::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get privacy" do
    get storefront_pages_privacy_url
    assert_response :success
  end

  test "should get terms" do
    get storefront_pages_terms_url
    assert_response :success
  end

  test "should get contact" do
    get storefront_pages_contact_url
    assert_response :success
  end
end
