module ExpensesHelper
  def self.auto_find_category(expense)
    relatable = expense.user.expenses.where("raw_description == ? AND id != ?", expense.raw_description, expense.id).last
    expense.update(category: relatable.category, subcategory: relatable.subcategory) if relatable
  end
end
