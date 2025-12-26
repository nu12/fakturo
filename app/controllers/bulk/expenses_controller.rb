class Bulk::ExpensesController < ApplicationController
  before_action :set_expenses

  def update
    params.expect(:subcategory_id)
    subcategory = Subcategory.find(params[:subcategory_id])
    @expenses.each do | expense |
      expense.update(category: subcategory.category, subcategory: subcategory)
    end
    redirect_with_message_or_error "Expenses were successfully transfered."
  end

  def destroy
    @expenses.each do | expense |
      expense.destroy
    end
    redirect_with_message_or_error "Expenses were successfully destroyed."
  end

  private  
  def set_expenses
    params.expect(:selected)
    selected_expenses = params[:selected].split(",")
    @expenses = Expense.where(id: selected_expenses)
  end

  def redirect_with_message_or_error(msg)
    errors = @expenses.map { |e| e[:errors] }.flatten.select { |e| e != nil }
    if errors.count > 0
      flash[:alert] = "#{errors.full_messages.join('. ')}."
    else
      flash[:notice] = msg
    end
    redirect_to request.referer, status: :see_other
  end
end
