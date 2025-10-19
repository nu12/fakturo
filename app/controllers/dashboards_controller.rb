class DashboardsController < ApplicationController
  before_action :authenticate_user!

  before_action { set_active_page("dashboards") }

  def index
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards" } ]
  end

  def category_by_statement
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Category by statement" } ]
    @statements = Statement.accessible_by(current_ability)
    authorize! :read, Statement, @statements
    if params[:statement_id]
      @cat = Expense.accessible_by(current_ability)
        .unscoped.valid.where(statement_id: params[:statement_id])
        .group_by_category
      authorize! :read, Expense, @cat
      @sub = Expense.accessible_by(current_ability)
        .unscoped.valid.where(statement_id: params[:statement_id])
        .group_by_subcategory
      authorize! :read, Expense, @sub

      @option = double_pie_chart(
        { name: "Categories", data: @cat },
        { name: "Sub-categories", data: @sub }
      )
    end
  end

  def category_by_year
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Category by year" } ]
    if params[:year]
      @cat = Expense.accessible_by(current_ability)
      .unscoped.valid.where("cast(strftime('%Y', date) as int) = ?", params[:year])
      .group_by_category
      authorize! :read, Expense, @cat
      @sub = Expense.accessible_by(current_ability)
      .unscoped.valid.where("cast(strftime('%Y', date) as int) = ?", params[:year])
      .group_by_subcategory
      authorize! :read, Expense, @sub

      @option = double_pie_chart(
        { name: "Categories", data: @cat },
        { name: "Sub-categories", data: @sub }
      )
    end
  end

  def category_by_month
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Category by month" } ]
    if params[:year] && params[:month]
      @cat = Expense.accessible_by(current_ability)
      .unscoped.valid.where("cast(strftime('%Y', date) as int) = ? and cast(strftime('%m', date) as int) = ?", params[:year], params[:month])
      .group_by_category
      authorize! :read, Expense, @cat
      @sub = Expense.accessible_by(current_ability)
      .unscoped.valid.where("cast(strftime('%Y', date) as int) = ? and cast(strftime('%m', date) as int) = ?", params[:year], params[:month])
      .group_by_subcategory
      authorize! :read, Expense, @sub

      @option = double_pie_chart(
        { name: "Categories", data: @cat },
        { name: "Sub-categories", data: @sub }
      )
    end
  end

  private

  def double_pie_chart(primary, secondary)
    {
      tooltip: {
        trigger: "item",
        formatter: "{a} <br/>{b}: {c} ({d}%)"
      },
      series: [
        {
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
        }
      ]
    }
  end
end
