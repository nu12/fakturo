class Dashboards::DashboardsController < ApplicationController
  before_action { set_active_page("dashboards") }

  def index
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Dashboards" } ]
  end
end