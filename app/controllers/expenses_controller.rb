class ExpensesController < ApplicationController
  load_and_authorize_resource
  before_action :set_expense, only: %i[ show edit update destroy ]
  before_action { set_active_page("home") }

  # GET /expenses or /expenses.json
  def index
    @page = params[:page]||1
    @expenses = Expense.accessible_by(current_ability).paginate(page: @page).order(date: :asc)
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Expenses (Page #{@page})" } ]
  end

  # GET /expenses/1 or /expenses/1.json
  def show
    page = params[:page]||1
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Expenses (Page #{page})", path: expenses_page_path(page) }, { name: @expense.description } ]
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Expenses", path: expenses_path }, { name: "New" } ]
  end

  # GET /expenses/1/edit
  def edit
    render partial: "form", layout: false, locals: { expense: @expense, statements: Current.user.statements, categories: Current.user.categories, async: true }
  end

  # POST /expenses or /expenses.json
  def create
    @expense = Expense.new(expense_params)
    @expense.user = current_user

    respond_to do |format|
      if @expense.save
        format.html { redirect_to @expense, notice: "Expense was successfully created." }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        flash[:notice] = "Expense was successfully updated."
        format.json { render json: @expense, status: :ok }
      else
        flash[:alert] = "#{@expense.errors.full_messages.join('. ')}."
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy!

    respond_to do |format|
      flash[:notice] = "Expense was successfully destroyed."
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.expect(expense: [ :date, :description, :value, :comment, :ignore, :statement_id, :category_id, :subcategory_id ])
    end
end
