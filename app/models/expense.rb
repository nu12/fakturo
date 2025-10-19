class Expense < ApplicationRecord
  belongs_to :statement
  belongs_to :category
  belongs_to :subcategory
  belongs_to :user

  default_scope { order(date: :asc, description: :asc) }

  def self.valid
    where(ignore: false)
  end

  def self.group_by_category
    order(category_id: :desc).joins(:category).select("categories.name as name, sum(value) as value").group("categories.name")
  end

  def self.group_by_subcategory
    order(category_id: :desc).joins(:subcategory).select("subcategories.name as name, sum(value) as value").group("subcategories.name")
  end
end
