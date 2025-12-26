class Bulk::ExpensesController < ApplicationController
  def update
    params.expect(:selected, :subcategory_id)
    expenses_to_transfer = params[:selected].split(",")
    expenses = Expense.where(id: expenses_to_transfer)
    subcategory = Subcategory.find(params[:subcategory_id])
    expenses.each do | expense |
      expense.update(category: subcategory.category, subcategory: subcategory)
    end
    errors = expenses.map { |e| e[:errors] }.flatten.select { |e| e != nil }
    if errors.count > 0
      flash[:alert] = "#{errors.full_messages.join('. ')}."
    else
      flash[:notice] = "Expenses were successfully transfered."
    end
    redirect_to request.referer, status: :see_other
  end

  def destroy
    params.expect(:selected)
    expenses_to_delete = params[:selected].split(",")
    expenses = Expense.where(id: expenses_to_delete)
    expenses.each do | expense |
      expense.destroy
    end
    errors = expenses.map { |e| e[:errors] }.flatten.select { |e| e != nil }
    if errors.count > 0
      flash[:alert] = "#{errors.full_messages.join('. ')}."
    else
      flash[:notice] = "Expenses were successfully destroyed."
    end
    redirect_to request.referer, status: :see_other
  end
end
