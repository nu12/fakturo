class SubcategoriesController < ApplicationController
  load_and_authorize_resource :category
  before_action :set_subcategory, only: %i[ show edit update destroy ]
  before_action :set_category, only: %i[ index new create edit update destroy ]
  before_action { set_active_page("home") }

  # GET /subcategories or /subcategories.json
  def index
    @subcategories = Subcategory.accessible_by(current_ability).where(category_id: @category.id)
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Categories", path: categories_path }, { name: @category.name, path: category_path(@category) }, { name: "Sub-categories" } ]
  end

  # GET /subcategories/1 or /subcategories/1.json
  def show
    page = params[:page]||1
    @paginated_expenses = @subcategory.expenses.paginate(page: page).order(date: :asc)
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Categories", path: categories_path }, { name: @category.name, path: category_path(@category) }, { name: "Sub-categories", path: category_subcategories_path(@category) }, { name: @subcategory.name } ]
  end

  # GET /subcategories/new
  def new
    @subcategory = Subcategory.new
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Categories", path: categories_path }, { name: @category.name, path: category_path(@category) }, { name: "Sub-categories", path: category_subcategories_path(@category) }, { name: "New" } ]
  end

  # GET /subcategories/1/edit
  def edit
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Categories", path: categories_path }, { name: @category.name, path: category_path(@category) }, { name: "Sub-categories", path: category_subcategories_path(@category) }, { name: @subcategory.name, path: category_subcategory_path(@category, @subcategory) }, { name: "Edit" } ]
  end

  # POST /subcategories or /subcategories.json
  def create
    @subcategory = Subcategory.new(subcategory_params)
    @subcategory.category = @category
    @subcategory.user = current_user

    respond_to do |format|
      if @subcategory.save
        format.html { redirect_to category_subcategories_path(@category), notice: "Subcategory was successfully created." }
        format.json { render :show, status: :created, location: @subcategory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subcategories/1 or /subcategories/1.json
  def update
    respond_to do |format|
      if @subcategory.update(subcategory_params)
        format.html { redirect_to category_subcategory_path(@category, @subcategory), notice: "Subcategory was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @subcategory }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subcategories/1 or /subcategories/1.json
  def destroy
    @subcategory.destroy!

    respond_to do |format|
      format.html { redirect_to category_subcategories_path(@category), notice: "Subcategory was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def transfer
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
    redirect_to category_subcategory_path(subcategory.category, subcategory), status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subcategory
      params.permit(:id, :subcategory_id)
      @subcategory = Subcategory.find(params[:id] || params[:subcategory_id])
    end

    def set_category
      @category = Category.find(params.expect(:category_id))
    end

    # Only allow a list of trusted parameters through.
    def subcategory_params
      params.expect(subcategory: [ :name, :description ])
    end
end
