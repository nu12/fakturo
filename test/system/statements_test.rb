require "application_system_test_case"

class StatementsTest < ApplicationSystemTestCase
  setup do
    login_as(users(:one))
    @statement = statements(:one)
  end

  test "visiting the index" do
    visit statements_url
    assert_selector "h1", text: "Statements"
  end

  test "should create statement" do
    visit statements_url
    click_on "New Statement"

    fill_in "Date", with: @statement.date
    select(@statement.source.name, from: "statement_source_id")
    click_on "Save"

    assert_content "Statement was successfully created"
  end

  test "should update statement" do
    visit statement_url(@statement)
    click_on "Edit this statement", match: :first

    fill_in "Date", with: @statement.date
    select(@statement.source.name, from: "statement_source_id")
    click_on "Save"

    assert_content "Statement was successfully updated"
  end

  test "should edit Statement's expenses" do
    visit statement_url(@statement)
    within("table.table-striped") do
      find_button(match: :first).click
    end
    check("expense_ignore", visible: false)
    click_on "Save changes", visible: false

    assert_content "Expense was successfully updated"
    # assert_equal([], page.driver.browser.logs.get(:browser))
  end

  test "should destroy Statement" do
    visit statement_url(@statement)
    click_on "Delete this statement"

    assert_text "Yes, delete this statement"
    click_on "Yes, delete this statement"
  end
end
