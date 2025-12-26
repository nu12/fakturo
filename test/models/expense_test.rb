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
    expenses = user.expenses.valid.group_by_category

    assert expenses[0].name == "CatOne"
    assert expenses[0].value == 23.03

    assert expenses[1].name == "CatThree"
    assert expenses[1].value == 13.03
  end

  test "group by subcategory" do
    user = users(:one)
    expenses = user.expenses.valid.group_by_subcategory

    assert expenses[0].name == "SubOne"
    assert expenses[0].value == 23.03

    assert expenses[1].name == "SubThree"
    assert expenses[1].value == 13.03
  end

  test "year to be adjusted" do
    statement = statements(:one)
    statement.update(is_upload: true)
    cat, sub = statement.user.uncategorized
    same_year = Expense.create(date: "2020-01-01", description: "Same year", value: 92.11, statement: statement, user: statement.user, category: cat, subcategory: sub)
    assert_equal(2020, same_year.date.year)
    last_year = Expense.create(date: "2020-12-20", description: "Last year", value: 528.81, statement: statement, user: statement.user, category: cat, subcategory: sub)
    assert_equal(2019, last_year.date.year)
  end

  test "year not to be adjusted" do
    statement = statements(:two)
    statement.update(is_upload: true)
    cat, sub = statement.user.uncategorized
    previous_month = Expense.create(date: "2020-01-12", description: "Previous month, same year", value: 12.98, statement: statement, user: statement.user, category: cat, subcategory: sub)
    assert_equal(2020, previous_month.date.year)
  end
end
