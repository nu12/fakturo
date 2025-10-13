class Expense < ApplicationRecord
  belongs_to :document
  belongs_to :subcategory
end
