require "test_helper"

class Storefront::CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get storefront_categories_index_url
    assert_response :success
  end

  test "should get show" do
    get storefront_categories_show_url
    assert_response :success
  end
end
