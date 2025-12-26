require "test_helper"

class ExpensesHelperTest < ActiveSupport::TestCase
  test "find category" do
    us, ca, su, so, st, ex = ActiveSupport::Helper.bootstrap
    uncat, unsub = us.uncategorized
    e1 = Expense.create(date: "2020-01-12", raw_description: "autocat", description: "To be found", value: 12.98, statement: st, user: us, category: uncat, subcategory: unsub)
    assert_equal("Uncategorized", e1.category.name)
    assert_equal("Uncategorized", e1.subcategory.name)

    ExpensesHelper.auto_find_category e1
    assert_equal("Bootstrap", e1.category.name)
    assert_equal("Bootstrap", e1.subcategory.name)

    e2 = Expense.create(date: "2020-01-12", raw_description: "none", description: "Not to be found", value: 12.98, statement: st, user: us, category: uncat, subcategory: unsub)
    ExpensesHelper.auto_find_category e2
    assert_equal("Uncategorized", e2.category.name)
    assert_equal("Uncategorized", e2.subcategory.name)
  end
end
