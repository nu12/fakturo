class DashboardsController < ApplicationController
  before_action { set_active_page("dashboards") }

  def index
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards" } ]
  end

  def statement
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Category by statement" } ]
    @statements = policy_scope(Statement).all
    if params[:statement_id]
      @statement = Statement.find(params[:statement_id])
      authorize @statement, policy_class: StatementPolicy
      @cat = policy_scope(Expense).unscoped
        .valid.where(statement_id: params[:statement_id])
        .group_by_category
      @sub = policy_scope(Expense).unscoped
        .valid.where(statement_id: params[:statement_id])
        .group_by_subcategory

      @option = double_pie_chart(
        { name: "Categories", data: @cat },
        { name: "Sub-categories", data: @sub }
      )
    end
  end

  def year
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Category by year" } ]
    if params[:year]
      @cat = policy_scope(Expense)
      .valid.where("cast(strftime('%Y', date) as int) = ?", params[:year])
      .group_by_category
      @sub = policy_scope(Expense)
      .valid.where("cast(strftime('%Y', date) as int) = ?", params[:year])
      .group_by_subcategory

      @option = double_pie_chart(
        { name: "Categories", data: @cat },
        { name: "Sub-categories", data: @sub }
      )
    end
  end

  def month
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Category by month" } ]
    if params[:year] && params[:month]
      @cat = policy_scope(Expense)
      .valid.where("cast(strftime('%Y', date) as int) = ? and cast(strftime('%m', date) as int) = ?", params[:year], params[:month])
      .group_by_category
      @sub = policy_scope(Expense)
      .valid.where("cast(strftime('%Y', date) as int) = ? and cast(strftime('%m', date) as int) = ?", params[:year], params[:month])
      .group_by_subcategory

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
