class Expense < ApplicationRecord
  belongs_to :statement
  belongs_to :category
  belongs_to :subcategory
  belongs_to :user

  scope :between_dates, lambda{ |start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date ) }
  scope :ordered, lambda{ order(date: :asc, description: :asc) }
  scope :valid, lambda{ where(ignore: false) }

  def self.group_by_category
    order(category_id: :desc).joins(:category).select("categories.id as id, categories.name as name, sum(value) as value").group("categories.id", "categories.name")
  end

  def self.group_by_subcategory
    order(category_id: :desc).joins(:subcategory).select("subcategories.id as id, subcategories.name as name, sum(value) as value").group("subcategories.id", "subcategories.name")
  end
end
