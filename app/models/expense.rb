class Expense < ApplicationRecord
  belongs_to :statement
  belongs_to :category
  belongs_to :subcategory
  belongs_to :user

  scope :between_dates, lambda { |start_date, end_date| where("date >= ? AND date <= ?", start_date, end_date) }
  scope :ordered, lambda { order(date: :asc, description: :asc) }
  scope :valid, lambda { where(ignore: false) }

  before_create :adjust_year

  def self.group_by_category
    order(category_id: :desc).joins(:category).select("categories.id as id, categories.name as name, sum(value) as value").group("categories.id", "categories.name")
  end

  def self.group_by_subcategory
    order(category_id: :desc).joins(:subcategory).select("subcategories.id as id, subcategories.name as name, sum(value) as value").group("subcategories.id", "subcategories.name")
  end
  private

  ## Statements usually contain expenses from previous month, meaning that the Statement from January
  # is likely to contain most of expenses from december. 
  #
  # Only affects creation of expenses from uploaded statements.
  # Don't need to run the change if dates from statement and expense have the same month.
  # The adjusted year is the year of previous month.
  def adjust_year
    return unless self.statement.is_upload
    return if self.date.month == self.statement.date.month
    self.date = self.date.change(year: (self.statement.date - 1.month).year)
  end
end
