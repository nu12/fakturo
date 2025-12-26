class SubcategoriesController < ApplicationController
  before_action :set_subcategory, only: %i[ show edit update destroy ]
  before_action :set_category, only: %i[ index show new create edit update destroy ]
  before_action { set_active_page("home") }

  # GET /subcategories or /subcategories.json
  def index
    @subcategories = policy_scope(Subcategory).where(category_id: @category.id)
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
    @subcategory.user = Current.user

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
    respond_to do |format|
      if @subcategory.destroy!
        format.html { redirect_to category_subcategories_path(@category), notice: "Subcategory was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      else
        format.html { redirect_to category_subcategories_path(@category), alert: "Subcategory cannot be destroyed.", status: :see_other }
        format.json { render json: "Subcategory cannot be destroyed.", status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subcategory
      params.permit(:id, :subcategory_id)
      @subcategory = Subcategory.find(params[:id] || params[:subcategory_id])
      authorize @subcategory
    end

    def set_category
      @category = Category.find(params.expect(:category_id))
      authorize @category, policy_class: SubcategoryPolicy
    end

    # Only allow a list of trusted parameters through.
    def subcategory_params
      params.expect(subcategory: [ :name, :description ])
    end
end
