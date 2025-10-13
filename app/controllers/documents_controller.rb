class DocumentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_document, only: %i[ show edit update destroy ]
  before_action :load_sources, only: %i[ new create edit ]
  before_action { set_active_page("home") }

  # GET /documents or /documents.json
  def index
    @documents = Document.accessible_by(current_ability)
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Documents" } ]
  end

  # GET /documents/1 or /documents/1.json
  def show
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Documents", path: documents_path }, { name: @document.name } ]
  end

  # GET /documents/new
  def new
    @document = Document.new
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Documents", path: documents_path }, { name: "New" } ]
  end

  # GET /documents/1/edit
  def edit
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Documents", path: documents_path }, { name: @document.name, path: document_path(@document) }, { name: "Edit" } ]
  end

  # POST /documents or /documents.json
  def create
    @document = Document.new(document_params)
    @document.user = current_user

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: "Document was successfully created." }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: "Document was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1 or /documents/1.json
  def destroy
    @document.destroy!

    respond_to do |format|
      format.html { redirect_to documents_path, notice: "Document was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params.expect(:id))
    end

    def load_sources
      @sources = Source.accessible_by(current_ability)
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.expect(document: [ :name, :year, :month, :is_upload, :source_id ])
    end
end
