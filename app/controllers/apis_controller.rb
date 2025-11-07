class ApisController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user
  def total
    result = policy_scope(Expense)
    .valid
    .joins(:category, :subcategory)
    .select("categories.name as category_name, subcategories.name as subcategory_name, sum(value) as value, count(*) as count")
    .group("category_name", "subcategory_name")
    render json: result
  end

  def monthly
    result = policy_scope(Expense)
    .valid
    .joins(:category, :subcategory)
    .select("categories.name as category_name, subcategories.name as subcategory_name, cast(strftime('%Y', date) as int) as year, cast(strftime('%m', date) as int) as month, sum(value) as value, count(*) as count")
    .group("category_name", "subcategory_name", "year", "month")
    render json: result
  end

  private
  def set_user
    current_user = User.where(uuid: params["uuid"], access_token: params["access_token"], access_token_enabled: true).where("access_token_expiry_date >= ?", Time.now).first
    if current_user
      start_new_session_for(current_user)
    else
      render json: []
    end
  end
end
