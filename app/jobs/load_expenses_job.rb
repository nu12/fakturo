class LoadExpensesJob < ApplicationJob
  queue_as :default

  def perform(sp)
    p "Loading expenses job for #{sp.uuid}"
    results = JSON.load(sp.result)
    results.each do | result |
      sp.statement.expenses << Expense.create!(date: result['date'], description: result['date'], value: result['value'], statement: sp.statement, user: sp.user, category: sp.user.subcategories.first.category, subcategory: sp.user.subcategories.first)
    end
    p "Statement processing completed for #{sp.uuid}"
  end
end
