require "test_helper"

class BulkControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
    @subcategory = subcategories(:one)
  end

  test "should transfer expenses" do
    put bulk_expenses_url, params: { selected: "1", subcategory_id: @subcategory.id }, headers: { "HTTP_REFERER" => root_url }
    assert_response :see_other
    assert_redirected_to root_url
  end

  test "should delete expenses" do
    expenses = [expenses(:one), expenses(:two)]
    assert_difference("Expense.count", -2) do
      delete bulk_expenses_url, params: { selected: expenses.map{|e| e.id}.join(",") }, headers: { "HTTP_REFERER" => root_url }
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
end
