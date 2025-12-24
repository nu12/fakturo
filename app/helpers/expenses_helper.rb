module ExpensesHelper
  def self.auto_find_category(expense)
    relatable = expense.user.expenses.where(raw_description: expense.raw_description).first
    expense.update(category: relatable.category, subcategory: relatable.subcategory)
  end
end
