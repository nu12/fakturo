class LoadExpensesJob < ApplicationJob
  queue_as :default

  def perform(sp)
    p "Loading expenses job for #{sp.uuid}"
    results = JSON.load(sp.result)
    results.each do | result |
      cat, sub = sp.user.uncategorized
      sp.statement.expenses << Expense.create!(date: result["date"], description: result["description"], value: result["value"], statement: sp.statement, user: sp.user, category: cat, subcategory: sub)
    end
    sp.result = nil
    sp.save
    p "Statement processing completed for #{sp.uuid}"
  end
end
