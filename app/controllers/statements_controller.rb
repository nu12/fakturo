class StatementsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_statement, only: %i[ show edit update destroy ]
  before_action :load_sources, only: %i[ new create edit ]
  before_action { set_active_page("home") }

  # GET /statements or /statements.json
  def index
    @statements = Statement.accessible_by(current_ability)
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Statements" } ]
  end

  # GET /statements/1 or /statements/1.json
  def show
    page = params[:page]||1
    @paginated_expenses = @statement.expenses.paginate(page: page).order(date: :asc)
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Statements", path: statements_path }, { name: @statement.id } ]
  end

  # GET /statements/new
  def new
    @statement = Statement.new
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Statements", path: statements_path }, { name: "New" } ]
  end

  # GET /statements/1/edit
  def edit
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Statements", path: statements_path }, { name: @statement.id, path: statement_path(@statement) }, { name: "Edit" } ]
  end

  # POST /statements or /statements.json
  def create
    @statement = Statement.new(statement_params)
    @statement.user = current_user

    respond_to do |format|
      if @statement.save
        format.html { redirect_to @statement, notice: "Statement was successfully created." }
        format.json { render :show, status: :created, location: @statement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @Statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statements/1 or /statements/1.json
  def update
    respond_to do |format|
      if @statement.update(statement_params)
        format.html { redirect_to @statement, notice: "Statement was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @statement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @Statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statements/1 or /statements/1.json
  def destroy
    @statement.destroy!

    respond_to do |format|
      format.html { redirect_to statements_path, notice: "Statement was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_statement
      @statement = Statement.find(params.expect(:id))
    end

    def load_sources
      @sources = Source.accessible_by(current_ability)
    end

    # Only allow a list of trusted parameters through.
    def statement_params
      params.expect(statement: [ :year, :month, :is_upload, :source_id ])
    end
end
