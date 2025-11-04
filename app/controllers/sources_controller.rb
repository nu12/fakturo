class SourcesController < ApplicationController
  load_and_authorize_resource
  before_action :set_source, only: %i[ show edit update destroy ]
  before_action { set_active_page("home") }

  # GET /sources or /sources.json
  def index
    @sources = Source.accessible_by(current_ability)
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Sources" } ]
  end

  # GET /sources/1 or /sources/1.json
  def show
    page = params[:page]||1
    @paginated_expenses = @source.expenses.paginate(page: page).order(date: :asc)
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Sources", path: sources_path }, { name: @source.name } ]
  end

  # GET /sources/new
  def new
    @source = Source.new
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Sources", path: sources_path }, { name: "New" } ]
  end

  # GET /sources/1/edit
  def edit
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Sources", path: sources_path }, { name: @source.name, path: source_path(@source) }, { name: "Edit" } ]
  end

  # POST /sources or /sources.json
  def create
    @source = Source.new(source_params)
    @source.user = current_user

    respond_to do |format|
      if @source.save
        format.html { redirect_to @source, notice: "Source was successfully created." }
        format.json { render :show, status: :created, location: @source }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sources/1 or /sources/1.json
  def update
    respond_to do |format|
      if @source.update(source_params)
        format.html { redirect_to @source, notice: "Source was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @source }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sources/1 or /sources/1.json
  def destroy
    @source.destroy!

    respond_to do |format|
      format.html { redirect_to sources_path, notice: "Source was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_source
      @source = Source.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def source_params
      params.expect(source: [ :name, :user_id ])
    end
end
