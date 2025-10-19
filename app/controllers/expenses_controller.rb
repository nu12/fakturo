class ExpensesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_expense, only: %i[ show edit update destroy render_form]
  before_action :load_categories, only: %i[ new create edit render_form ]
  before_action :load_statements, only: %i[ new create edit render_form ]
  before_action { set_active_page("home") }

  # GET /expenses or /expenses.json
  def index
    @page = params[:page]||1
    @expenses = Expense.accessible_by(current_ability).paginate(page: @page).order(id: :asc)
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Expenses" } ]
  end

  # GET /expenses/1 or /expenses/1.json
  def show
    if params[:subcategory_id]
      subcategory = Subcategory.find(params[:subcategory_id])
      @breadcrumb = [ { name: "Home", path: root_path }, { name: "Categories", path: categories_path }, { name: subcategory.category.name, path: category_path(subcategory.category) }, { name: "Sub-categories", path: category_subcategories_path }, { name: subcategory.name, path: category_subcategory_path(subcategory.category, subcategory) }, { name: "Expense: #{@expense.description}" } ]
    elsif params[:category_id]
      category = Category.find(params[:category_id])
      @breadcrumb = [ { name: "Home", path: root_path }, { name: "Categories", path: categories_path }, { name: category.name, path: category_path(category) }, { name: "Expense: #{@expense.description}" } ]
    elsif params[:source_id]
      source = Source.find(params[:source_id])
      @breadcrumb = [ { name: "Home", path: root_path }, { name: "Sources", path: sources_path }, { name: source.name, path: source_path(source) }, { name: "Expense: #{@expense.description}" } ]
    elsif params[:statement_id]
      statement = Statement.find(params[:statement_id])
      @breadcrumb = [ { name: "Home", path: root_path }, { name: "Statements", path: statements_path }, { name: statement.id, path: statement_path(statement) }, { name: "Expense: #{@expense.description}" } ]
    else
      page = params[:page]||1
      @breadcrumb = [ { name: "Home", path: root_path }, { name: "Expenses (Page #{page})", path: expenses_page_path(page) }, { name: @expense.description } ]
    end
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Expenses", path: expenses_path }, { name: "New" } ]
  end

  # GET /expenses/1/edit
  def edit
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Expenses", path: expenses_path }, { name: @expense.description, path: expense_path(@expense) }, { name: "Edit" } ]
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
        format.html { redirect_to @expense, notice: "Expense was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy!

    respond_to do |format|
      format.html { redirect_to expenses_path, notice: "Expense was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def render_form
    render partial: "inner_form", layout: false, locals: {expense: @expense, statements: @statements, categories: @categories, async: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params.expect(:id))
    end

    def load_categories
      @categories = Category.includes(:subcategories).where(user_id: current_user.id)
    end

    def load_statements
      @statements = Statement.where(user_id: current_user.id)
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.expect(expense: [ :date, :description, :value, :comment, :ignore, :statement_id, :category_id, :subcategory_id ])
    end
end
