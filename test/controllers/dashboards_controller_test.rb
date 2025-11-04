require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "should get index" do
    get dashboards_path
    assert_response :success
  end

  test "should get category_by_statement" do
    get category_by_statement_url
    assert_response :success
  end

  test "should get category_by_month" do
    get category_by_month_url
    assert_response :success
  end

  test "should get category_by_year" do
    get category_by_year_url
    assert_response :success
  end
end
