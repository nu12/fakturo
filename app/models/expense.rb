class Expense < ApplicationRecord
  belongs_to :statement
  belongs_to :category
  belongs_to :subcategory
  belongs_to :user
end
