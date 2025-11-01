class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private
  def set_active_page(page)
    @active = page
  end
  def load_categories
    @categories = Category.includes(:subcategories).where(user_id: current_user.id)
  end

  def load_statements
    @statements = Statement.where(user_id: current_user.id)
  end
end
