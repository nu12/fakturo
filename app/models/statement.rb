class Statement < ApplicationRecord
  belongs_to :source
  belongs_to :user
  has_many :expenses, dependent: :destroy

  default_scope { order(year: :asc, month: :asc, source_id: :asc) }

  before_save :set_month_and_year

  def value
    self.expenses.select { |e| !e[:ignore] }.collect { |k, v| k[:value] }.sum
  end

  private
  def set_month_and_year
    self.month = self.date.month
    self.year = self.date.year
  end
end
