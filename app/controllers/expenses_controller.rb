class ExpensesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_expense, only: %i[ show edit update destroy ]
  before_action :load_categories, only: %i[ new create edit ]
  before_action :load_documents, only: %i[ new create edit ]
  before_action {set_active_page('home')}

  # GET /expenses or /expenses.json
  def index
    @page = params[:page]||1
    @expenses = Expense.accessible_by(current_ability).paginate(page: @page).order(id: :asc)
    @breadcrumb = [{name: "Home", path: root_path}, {name: "Expenses"}]
  end

  # GET /expenses/1 or /expenses/1.json
  def show
    if params[:subcategory_id]
      subcategory = Subcategory.find(params[:subcategory_id])
      @breadcrumb = [{name: "Home", path: root_path}, {name: "Categories", path: categories_path}, {name: subcategory.category.name, path: category_path(subcategory.category)}, {name: "Sub-categories", path: category_subcategories_path}, {name: subcategory.name, path: category_subcategory_path(subcategory.category, subcategory)}, {name: "Expense: #{@expense.description}"}]
    elsif params[:category_id]
      category = Category.find(params[:category_id])
      @breadcrumb = [{name: "Home", path: root_path}, {name: "Categories", path: categories_path}, {name: category.name, path: category_path(category)}, {name: "Expense: #{@expense.description}"}]
    elsif params[:source_id]
      source = Source.find(params[:source_id])
      @breadcrumb = [{name: "Home", path: root_path}, {name: "Sources", path: sources_path}, {name: source.name, path: source_path(source)}, {name: "Expense: #{@expense.description}"}]
    elsif params[:document_id]
      document = Document.find(params[:document_id])
      @breadcrumb = [{name: "Home", path: root_path}, {name: "Documents", path: documents_path}, {name: document.name, path: document_path(document)}, {name: "Expense: #{@expense.description}"}]
    else
      page = params[:page]||1
      @breadcrumb = [{name: "Home", path: root_path}, {name: "Expenses (Page #{page})", path: expenses_page_path(page)}, {name: @expense.description}]
    end
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    @breadcrumb = [{name: "Home", path: root_path}, {name: "Expenses", path: expenses_path}, {name: "New"}]
  end

  # GET /expenses/1/edit
  def edit
    @breadcrumb = [{name: "Home", path: root_path}, {name: "Expenses", path: expenses_path}, {name: @expense.description, path: expense_path(@expense)}, {name: "Edit"}]
  end

  # POST /expenses or /expenses.json
  def create
    @expense = Expense.new(expense_params)
    p @expense.value.to_f

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params.expect(:id))
    end

    def load_categories
      @categories = Category.includes(:subcategories).where(user_id: current_user.id)
    end

    def load_documents
      @documents = Document.where(user_id: current_user.id)
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.expect(expense: [ :date, :description, :value, :comment, :ignore, :document_id, :subcategory_id ])
    end
end
