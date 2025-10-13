require "application_system_test_case"

class ExpensesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:one)
    @expense = expenses(:one)
  end

  test "visiting the index" do
    visit expenses_page_url(1)
    assert_selector "h1", text: "Expenses"
  end

  test "should create expense" do
    visit expenses_page_url(1)
    click_on "New Expense"

    fill_in "Date", with: @expense.date
    check "Ignore" if @expense.ignore
    select(@expense.document.name, from: 'expense_document_id')
    select(@expense.subcategory.category.name, from: 'category_id')
    select(@expense.subcategory.name, from: 'subcategory_id')
    fill_in "Value", with: @expense.value
    click_on "Save"

    assert_text "Expense was successfully created"
    click_on "Expenses"
  end

  test "should update Expense" do
    visit expense_page_url(1,@expense)
    click_on "Edit this expense", match: :first

    fill_in "Date", with: @expense.date.to_s
    check "Ignore" if @expense.ignore
    select(@expense.document.name, from: 'expense_document_id')
    select(@expense.subcategory.category.name, from: 'category_id')
    select(@expense.subcategory.name, from: 'subcategory_id')
    fill_in "Value", with: @expense.value
    click_on "Save"

    assert_text "Expense was successfully updated"
    click_on "Expenses"
  end

  test "should destroy Expense" do
    visit expense_url(@expense)
    click_on "Delete this expense"

    assert_text "Yes, delete this expense"
    click_on "Yes, delete this expense"
  end
end
