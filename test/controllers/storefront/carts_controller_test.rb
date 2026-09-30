require "test_helper"

class Storefront::CartsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get storefront_carts_show_url
    assert_response :success
  end

  test "should get update" do
    get storefront_carts_update_url
    assert_response :success
  end

  test "should get destroy" do
    get storefront_carts_destroy_url
    assert_response :success
  end
end
