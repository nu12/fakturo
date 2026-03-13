class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  private
  def set_active_page(page)
    @active = page
  end

  def set_origin_url
    session[:origin_url] = request.original_url
  end
end
