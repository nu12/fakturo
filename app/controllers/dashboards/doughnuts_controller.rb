class Dashboards::DoughnutsController < Dashboards::DashboardsController
  def statement
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Category by statement" } ]
    @statements = policy_scope(Statement).all
    if params[:statement_id]
      @statement = Statement.find(params[:statement_id])
      authorize @statement, policy_class: StatementPolicy
      @cat = policy_scope(Expense)
        .valid.where(statement: @statement)
        .group_by_category
      @sub = policy_scope(Expense)
        .valid.where(statement: @statement)
        .group_by_subcategory

      @option = double_pie_chart(
        { name: "Categories", data: @cat },
        { name: "Sub-categories", data: @sub }
      )
    end
  end

  def dates
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Category between dates" } ]
    if params[:start_date] && params[:end_date]
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @cat = policy_scope(Expense)
      .valid.between_dates(@start_date, @end_date)
      .group_by_category
      @sub = policy_scope(Expense)
      .valid.between_dates(@start_date, @end_date)
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
