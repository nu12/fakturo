class ApiController < ApplicationController
  before_action :set_user
  def total
    result = Expense.accessible_by(current_ability)
    .where(ignore: false)
    .joins(:category, :subcategory)
    .select("categories.name as category_name, subcategories.name as subcategory_name, sum(value) as value, count(*) as count")
    .group("category_name", "subcategory_name")
    render json: result
  end

  private
  def set_user
    current_user = User.where(uuid: params["uuid"], access_token: params["access_token"], access_token_enabled: true).where("access_token_expiry_date >= ?", Time.now).first
    @current_ability = Ability.new(current_user)
  end
end
