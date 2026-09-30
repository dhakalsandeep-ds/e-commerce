require "test_helper"

class Dashboard::AutomationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_automations_index_url
    assert_response :success
  end

  test "should get show" do
    get dashboard_automations_show_url
    assert_response :success
  end

  test "should get new" do
    get dashboard_automations_new_url
    assert_response :success
  end

  test "should get create" do
    get dashboard_automations_create_url
    assert_response :success
  end

  test "should get edit" do
    get dashboard_automations_edit_url
    assert_response :success
  end

  test "should get update" do
    get dashboard_automations_update_url
    assert_response :success
  end

  test "should get destroy" do
    get dashboard_automations_destroy_url
    assert_response :success
  end
end
