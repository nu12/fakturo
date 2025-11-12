class ApisController < ApplicationController
  allow_unauthenticated_access
  def total
    result = policy_scope(Expense)
    .valid
    .joins(:category, :subcategory)
    .select("categories.name as category_name, subcategories.name as subcategory_name, sum(value) as value, count(*) as count")
    .group("category_name", "subcategory_name")
    respond_to do |format|
      format.csv { render partial: "csv", layout: false, locals: { data: result } }
      format.json { render json: result }
    end
  end

  def monthly
    result = policy_scope(Expense)
    .valid
    .joins(:category, :subcategory)
    .select("categories.name as category_name, subcategories.name as subcategory_name, cast(strftime('%Y', date) as int) as year, cast(strftime('%m', date) as int) as month, sum(value) as value, count(*) as count")
    .group("category_name", "subcategory_name", "year", "month")
    respond_to do |format|
      format.csv { render partial: "csv", layout: false, locals: { data: result } }
      format.json { render json: result }
    end
  end
end
