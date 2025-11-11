require "application_system_test_case"

class DashboardsTest < ApplicationSystemTestCase
  setup do
    login_as(users(:one))
  end

  test "visiting the index" do
    visit dashboards_path
    assert_selector "h1", text: "Dashboards"
  end

  test "visiting statement (doughnuts)" do
    statement = statements(:one)

    visit statement_dashboards_doughnuts_path
    assert_no_selector "canvas"

    visit statement_dashboards_doughnuts_path(statement_id: statement.id)
    assert_selector "canvas"
  end

  test "visiting dates (doughnuts)" do
    start_date = expenses(:one)
    end_date = expenses(:two)

    visit dates_dashboards_doughnuts_path
    assert_no_selector "canvas"

    visit dates_dashboards_doughnuts_path(start_date: start_date, end_date: end_date)
    assert_selector "canvas"
  end

  test "visiting daily (bars)" do
    start_date = expenses(:one)
    end_date = expenses(:two)

    visit daily_dashboards_bars_path
    assert_no_selector "canvas"

    visit daily_dashboards_bars_path(start_date: start_date, end_date: end_date)
    assert_selector "canvas"
  end
end
