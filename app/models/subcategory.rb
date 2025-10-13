class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :expenses, dependent: :delete_all
end
