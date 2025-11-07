require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "should get index" do
    get dashboards_path
    assert_response :success
  end

  test "should get statement (doughnuts)" do
    get statement_dashboards_doughnuts_path
    assert_response :success
  end

  test "should get date (doughnuts)" do
    get dates_dashboards_doughnuts_path
    assert_response :success
  end

  test "should get daily (bars)" do
    get daily_dashboards_bars_path
    assert_response :success
  end
end
