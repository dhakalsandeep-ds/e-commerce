require "test_helper"

class Dashboard::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_orders_index_url
    assert_response :success
  end

  test "should get show" do
    get dashboard_orders_show_url
    assert_response :success
  end

  test "should get new" do
    get dashboard_orders_new_url
    assert_response :success
  end

  test "should get create" do
    get dashboard_orders_create_url
    assert_response :success
  end

  test "should get edit" do
    get dashboard_orders_edit_url
    assert_response :success
  end

  test "should get update" do
    get dashboard_orders_update_url
    assert_response :success
  end

  test "should get destroy" do
    get dashboard_orders_destroy_url
    assert_response :success
  end
end
