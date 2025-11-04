require "application_system_test_case"

class DashboardsTest < ApplicationSystemTestCase
  setup do
    login_as_user_one
  end

  test "visiting the index" do
    visit dashboards_url
    assert_selector "h1", text: "Dashboards"
  end

  test "visiting category by statement" do
    statement = statements(:one)

    visit category_by_statement_url
    assert_no_selector "canvas"

    visit category_by_statement_url(statement_id: statement.id)
    assert_selector "canvas"
  end

  test "visiting category by year" do
    statement = statements(:one)

    visit category_by_year_url
    assert_no_selector "canvas"

    visit category_by_year_url(year: statement.year)
    assert_selector "canvas"
  end

  test "visiting category by month" do
    statement = statements(:one)

    visit category_by_month_url
    assert_no_selector "canvas"

    visit category_by_month_url(year: statement.year, month: statement.month)
    assert_selector "canvas"
  end
end
