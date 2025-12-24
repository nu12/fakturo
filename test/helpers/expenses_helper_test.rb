require "test_helper"

class ExpensesHelperTest < ActiveSupport::TestCase
  test "find category" do
    us, ca, su, so, st, ex = ActiveSupport::Helper.bootstrap
    uncat, unsub = us.uncategorized
    e = Expense.create(date: "2020-01-12", raw_description: "autocat", description: "Any", value: 12.98, statement: st, user: us, category: uncat, subcategory: unsub)
    assert_equal("Uncategorized", e.category.name)
    assert_equal("Uncategorized", e.subcategory.name)

    ExpensesHelper.auto_find_category e
    assert_equal("Bootstrap", e.category.name)
    assert_equal("Bootstrap", e.subcategory.name)
  end
end
