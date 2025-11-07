class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]
  before_action { set_active_page("home") }

  # GET /categories or /categories.json
  def index
    @categories = policy_scope(Category).all
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Categories" } ]
  end

  # GET /categories/1 or /categories/1.json
  def show
    page = params[:page]||1
    @paginated_expenses = @category.expenses.paginate(page: page).order(date: :asc)
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Categories", path: categories_path }, { name: @category.name } ]
  end

  # GET /categories/new
  def new
    @category = Category.new
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Categories", path: categories_path }, { name: "New" } ]
  end

  # GET /categories/1/edit
  def edit
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Categories", path: categories_path }, { name: @category.name, path: category_path(@category) }, { name: "Edit" } ]
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)
    @category.user = Current.user

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: "Category was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy!

    respond_to do |format|
      format.html { redirect_to categories_path, notice: "Category was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      params.permit(:id, :category_id)
      @category = Category.find(params[:id] || params[:category_id])
      authorize @category
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.expect(category: [ :name, :description ])
    end
end
