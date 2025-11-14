class Statement < ApplicationRecord
  belongs_to :source
  belongs_to :user
  has_many :expenses, dependent: :destroy
  has_one_attached :file

  default_scope { order(year: :asc, month: :asc, source_id: :asc) }

  before_save :set_month_and_year

  def is_upload?
    self.file.attached?
  end

  def value
    self.expenses.select { |e| !e[:ignore] }.collect { |k, v| k[:value] }.sum
  end

  private
  def set_month_and_year
    self.month = self.date.month
    self.year = self.date.year
  end
end
