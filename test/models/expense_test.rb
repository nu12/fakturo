require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  test "get only valid expenses" do
    e = Expense.all.first
    e.ignore = true
    e.save
    assert Expense.valid.count < Expense.all.count
  end

  test "group by category" do
    es =  Expense.all.group_by_category
    assert es[0].name == "MyString"
    assert es[0].value == 2.0
  end

  test "group by subcategory" do
    es =  Expense.all.group_by_subcategory
    assert es[0].name == "SubOne"
    assert es[0].value == 1.0
  end
end
