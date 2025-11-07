class Dashboards::BarsController < Dashboards::DashboardsController
  def daily
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards", path: dashboards_path }, { name: "Daily amounts" } ]
    if params[:start_date] && params[:end_date]
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @expenses = policy_scope(Expense).ordered.valid.between_dates(@start_date, @end_date)
        .select("date as date, COUNT(id) as amount, SUM(value) as value").group(:date)
      @option = bar_line_chart(
        @expenses.map { |e| e[:date] },
        @expenses.map { |e| e[:amount] },
        @expenses.map { |e| e[:value] }
        )
    end
  end

  private
  def bar_line_chart(xAxis, bar, line)
    {
      tooltip: {
        trigger: "axis",
        axisPointer: {
          type: "cross",
          label: {
            backgroundColor: "#283b56"
          }
        }
      },
      xAxis: [
        {
          type: "category",
          boundaryGap: true,
          data: xAxis
        }
      ],
      yAxis: [
        {
          type: "value",
          scale: true,
          name: "Amount",
          max: bar.max || 0 + 1,
          min: 0,
          boundaryGap: [ 0.2, 0.2 ]
        },
        {
          type: "value",
          scale: true,
          name: "Value",
          max: line.max || 0 + 1,
          min: 0,
          boundaryGap: [ 0.2, 0.2 ]
        }
      ],
      series: [
        {
          name: "Amount",
          type: "bar",
          data: bar
        },
        {
          name: "Value",
          type: "line",
          yAxisIndex: 1,
          data: line
        }
      ]
    }
  end
end
