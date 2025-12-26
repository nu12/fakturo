require "application_system_test_case"

class ExpensesTest < ApplicationSystemTestCase
  setup do
    login_as(users(:one))
    @expense = expenses(:one)
  end

  test "visiting the index" do
    visit expenses_url
    assert_selector "h1", text: "Expenses"
  end

  test "should create expense" do
    visit expenses_url
    click_on "New Expense"

    fill_in "Date", with: @expense.date
    check "Ignore" if @expense.ignore
    select("#{@expense.statement.source.name} (#{@expense.statement.year}-#{'%02d' % @expense.statement.month})", from: "expense_statement_id")
    select(@expense.subcategory.category.name, from: "category_id")
    select(@expense.subcategory.name, from: "subcategory_id")
    fill_in "Value", with: @expense.value
    click_on "Save"

    assert_content "Expense was successfully created"
  end

  test "should update Expense" do
    visit page_expenses_url
    within("table.table-striped tbody") do
      find_button(match: :first).click
    end
    check("expense_ignore", visible: false)
    click_on "Save changes", visible: false

    assert_content "Expense was successfully updated"
  end

  test "should destroy Expense" do
    visit page_expenses_url
    within("table.table-striped tbody") do
      find_button(match: :first).click
    end
    click_on "Delete expense", visible: false

    assert_text "Expense was successfully destroyed"
  end
end
