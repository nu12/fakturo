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
    order(category_id: :desc).joins(:category).select("categories.id as id, categories.name as name, sum(value) as value").group("categories.id", "categories.name")
  end

  def self.group_by_subcategory
    order(category_id: :desc).joins(:subcategory).select("subcategories.id as id, subcategories.name as name, sum(value) as value").group("subcategories.id", "subcategories.name")
  end
end
