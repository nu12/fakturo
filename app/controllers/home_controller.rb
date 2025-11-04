class HomeController < ApplicationController
  def index
    @active = "home"
  end

  def policy
    @breadcrumb = [ { name: "Home", path: root_path }, { name: "Data & Privacy policy" } ]
    @active = "policy"
    render("guest/policy")
  end

end
