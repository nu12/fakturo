require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:one)
    @expense = expenses(:one)
  end

  test "should get index" do
    get expenses_url
    assert_response :success
  end

  test "should get new" do
    get new_expense_url
    assert_response :success
  end

  test "should create expense" do
    assert_difference("Expense.count") do
      post expenses_url, params: { expense: { date: "2025-12-31", statement_id: @expense.statement_id, ignore: @expense.ignore, category_id: @expense.category_id, subcategory_id: @expense.subcategory_id, value: @expense.value } }
    end

    assert_redirected_to expense_url(Expense.last)
  end

  test "should update expense" do
    patch expense_url(@expense, format: :json), params: { expense: { date: @expense.date, statement_id: @expense.statement_id, ignore: @expense.ignore, subcategory_id: @expense.subcategory_id, value: @expense.value } }
    assert_response :success
  end

  test "should destroy expense" do
    assert_difference("Expense.count", -1) do
      delete expense_url(@expense, format: :json)
    end

    assert_response :success
  end
end
