require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  test "valid" do
    e = Expense.all.first
    e.ignore = true
    e.save
    assert Expense.valid.count < Expense.all.count
  end

  test "ordered" do
    unordered = Expense.all
    assert unordered.first.date > unordered.last.date

    ordered = Expense.ordered
    assert ordered.ordered.first.date < ordered.ordered.last.date
  end

  test "between_dates" do
    assert Expense.all.count == 3
    assert Expense.between_dates("2025-09-24", "2025-09-25").count == 2
  end

  test "group by category" do
    es =  Expense.all.group_by_category
    assert es[0].name == "MyString"
    assert es[0].value == 1.0
  end

  test "group by subcategory" do
    es =  Expense.all.group_by_subcategory
    assert es[0].name == "SubOne"
    assert es[0].value == 1.0
  end
end
