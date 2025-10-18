class Subcategory < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :expenses, dependent: :delete_all
end
