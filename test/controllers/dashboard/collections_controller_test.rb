require "test_helper"

class Dashboard::CollectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_collections_index_url
    assert_response :success
  end

  test "should get new" do
    get dashboard_collections_new_url
    assert_response :success
  end

  test "should get create" do
    get dashboard_collections_create_url
    assert_response :success
  end

  test "should get edit" do
    get dashboard_collections_edit_url
    assert_response :success
  end

  test "should get update" do
    get dashboard_collections_update_url
    assert_response :success
  end

  test "should get destroy" do
    get dashboard_collections_destroy_url
    assert_response :success
  end
end
