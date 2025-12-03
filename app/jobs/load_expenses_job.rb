class LoadExpensesJob < ApplicationJob
  queue_as :default

  def perform(sp)
    p "Loading expenses job for #{sp.uuid}"
    results = JSON.load(sp.result)
    cat, sub = sp.user.uncategorized
    results.each do | result |
      sp.statement.expenses << Expense.create!(date: result["date"], description: result["description"], value: result["value"], statement: sp.statement, user: sp.user, category: cat, subcategory: sub)
    end
    sp.update(result: nil)
    p "Statement processing completed for #{sp.uuid}"
  end
end
