class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action { set_active_page("dashboards") }

  def index
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards" } ]
  end

  def category_by_document
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Category by document" } ]
    @documents = Document.accessible_by(current_ability)
    authorize! :read, Document, @documents
    if params[:document_id]
      @cat = Category.accessible_by(current_ability).order(id: :desc).joins(:expenses).where("expenses.document_id" => params[:document_id]).group(:name).sum("expenses.value").map { |k, v| { "name" => k, "value" => v } }
      authorize! :read, Category, @cat
      @sub = Subcategory.accessible_by(current_ability).order(category_id: :desc).joins(:expenses).where("expenses.document_id" => params[:document_id]).group(:name).sum("expenses.value").map { |k, v| { "name" => k, "value" => v } }
      authorize! :read, Subcategory, @sub

      @option = double_pie_chart(
        { name: "Categories", data: @cat },
        { name: "Sub-categories", data: @sub }
      )
    end
  end

  def category_by_year
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Category by year" } ]
    if params[:year]
      @cat = Category.accessible_by(current_ability).order(id: :desc).joins(:expenses).where("cast(strftime('%Y', expenses.date) as int) = ?", params[:year]).group(:name).sum("expenses.value").map { |k, v| { "name" => k, "value" => v } }
      authorize! :read, Category, @cat
      @sub = Subcategory.accessible_by(current_ability).order(category_id: :desc).joins(:expenses).where("cast(strftime('%Y', expenses.date) as int) = ?", params[:year]).group(:name).sum("expenses.value").map { |k, v| { "name" => k, "value" => v } }
      authorize! :read, Subcategory, @sub

      @option = double_pie_chart(
        { name: "Categories", data: @cat },
        { name: "Sub-categories", data: @sub }
      )
    end
  end

  def category_by_month
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Category by month" } ]
    if params[:year] && params[:month]
      @cat = Category.accessible_by(current_ability).order(id: :desc).joins(:expenses).where("cast(strftime('%Y', expenses.date) as int) = ? and cast(strftime('%m', expenses.date) as int) = ?", params[:year], params[:month]).group(:name).sum("expenses.value").map { |k, v| { "name" => k, "value" => v } }
      authorize! :read, Category, @cat
      @sub = Subcategory.accessible_by(current_ability).order(category_id: :desc).joins(:expenses).where("cast(strftime('%Y', expenses.date) as int) = ? and cast(strftime('%m', expenses.date) as int) = ?", params[:year], params[:month]).group(:name).sum("expenses.value").map { |k, v| { "name" => k, "value" => v } }
      authorize! :read, Subcategory, @sub

      @option = double_pie_chart(
        { name: "Categories", data: @cat },
        { name: "Sub-categories", data: @sub }
      )
    end
  end

  private

  def double_pie_chart(primary, secondary)
    {
        trigger: "item",
        formatter: "{a} <br/>{b}: {c} ({d}%)",
        series: [ {
          name: primary[:name],
          type: "pie",
          selectedMode: "single",
          radius: [ "45%", "60%" ],
          data: primary[:data]
        }, {
          name: secondary[:name],
          type: "pie",
          selectedMode: "single",
          label: {
            position: "inner",
            fontSize: 14
          },
          radius: [ "13%", "43%" ],
          data: secondary[:data]
        } ]
      }
  end
end
