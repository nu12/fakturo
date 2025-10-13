require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:one)
  end

  test "should get index" do
    get dashboards_path
    assert_response :success
  end

  test "should get category_by_document" do
    get dashboards_category_by_document_url
    assert_response :success
  end

  test "should get category_by_month" do
    get dashboards_category_by_month_url
    assert_response :success
  end

  test "should get category_by_year" do
    get dashboards_category_by_year_url
    assert_response :success
  end
end
