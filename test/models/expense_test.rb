require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  test "valid" do
    assert Expense.valid.count < Expense.all.count
  end

  test "ordered" do
    unordered = Expense.all
    assert unordered.first.date > unordered.last.date

    ordered = Expense.ordered
    assert ordered.ordered.first.date < ordered.ordered.last.date
  end

  test "between_dates" do
    assert Expense.all.count == 6
    assert Expense.between_dates("2020-01-01", "2020-01-02").count == 2
  end

  test "group by category" do
    user = users(:one)
    es = user.expenses.valid.group_by_category

    assert es[0].name == "CatOne"
    assert es[0].value == 23.03

    assert es[1].name == "CatThree"
    assert es[1].value == 13.03
  end

  test "group by subcategory" do
    user = users(:one)
    es = user.expenses.valid.group_by_subcategory

    assert es[0].name == "SubOne"
    assert es[0].value == 23.03

    assert es[1].name == "SubThree"
    assert es[1].value == 13.03
  end
end
