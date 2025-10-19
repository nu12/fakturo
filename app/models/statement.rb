class Statement < ApplicationRecord
  belongs_to :source
  belongs_to :user

  has_many :expenses, dependent: :destroy

  def value
    self.expenses.select { |e| !e[:ignore] }.collect { |k, v| k[:value] }.sum
  end
end
