require "application_system_test_case"

class DashboardsTest < ApplicationSystemTestCase
  setup do
    login_as_user_one
  end

  test "visiting the index" do
    visit dashboards_path
    assert_selector "h1", text: "Dashboards"
  end

  test "visiting category by statement" do
    statement = statements(:one)

    visit statement_dashboards_path
    assert_no_selector "canvas"

    visit statement_dashboards_path(statement_id: statement.id)
    assert_selector "canvas"
  end

  test "visiting category by year" do
    statement = statements(:one)

    visit year_dashboards_path
    assert_no_selector "canvas"

    visit year_dashboards_path(year: statement.year)
    assert_selector "canvas"
  end

  test "visiting category by month" do
    statement = statements(:one)

    visit month_dashboards_path
    assert_no_selector "canvas"

    visit month_dashboards_path(year: statement.year, month: statement.month)
    assert_selector "canvas"
  end
end
