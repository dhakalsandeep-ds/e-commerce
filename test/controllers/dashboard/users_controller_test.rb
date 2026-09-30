require "test_helper"

class Dashboard::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_users_index_url
    assert_response :success
  end

  test "should get show" do
    get dashboard_users_show_url
    assert_response :success
  end

  test "should get new" do
    get dashboard_users_new_url
    assert_response :success
  end

  test "should get create" do
    get dashboard_users_create_url
    assert_response :success
  end

  test "should get edit" do
    get dashboard_users_edit_url
    assert_response :success
  end

  test "should get update" do
    get dashboard_users_update_url
    assert_response :success
  end

  test "should get destroy" do
    get dashboard_users_destroy_url
    assert_response :success
  end
end
