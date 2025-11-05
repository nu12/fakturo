class HomeController < ApplicationController
  before_action { set_active_page("home") }

  def index
  end
end
