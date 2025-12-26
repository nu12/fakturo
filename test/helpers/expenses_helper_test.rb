require "test_helper"

class ExpensesHelperTest < ActiveSupport::TestCase
  test "find category" do
    us, ca, su, so, st, ex = ActiveSupport::Helper.bootstrap
    uncat, unsub = us.uncategorized
    found = Expense.create(date: "2020-01-12", raw_description: "autocat", description: "To be found", value: 12.98, statement: st, user: us, category: uncat, subcategory: unsub)
    assert_equal("Uncategorized", found.category.name)
    assert_equal("Uncategorized", found.subcategory.name)

    ExpensesHelper.auto_find_category found
    assert_equal("Bootstrap", found.category.name)
    assert_equal("Bootstrap", found.subcategory.name)

    not_found = Expense.create(date: "2020-01-12", raw_description: "none", description: "Not to be found", value: 12.98, statement: st, user: us, category: uncat, subcategory: unsub)
    ExpensesHelper.auto_find_category not_found
    assert_equal("Uncategorized", not_found.category.name)
    assert_equal("Uncategorized", not_found.subcategory.name)
  end
end
