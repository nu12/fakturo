class Expense < ApplicationRecord
  belongs_to :statement
  belongs_to :subcategory
end
