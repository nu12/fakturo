require "test_helper"

class StatementTest < ActiveSupport::TestCase
  test "statement value sum" do
    s = Statement.new
    s.expenses << Expense.new(value: 10.10)
    s.expenses << Expense.new(value: 2.22)
    s.expenses << Expense.new(value: 9.99, ignore: true)
    assert s.value == 12.32
  end

  test "extract year and month from date" do
    s = Statement.create(source: sources(:one), user: users(:one), date: "2025-10-20")
    assert s.month == 10
    assert s.year == 2025
  end
end
