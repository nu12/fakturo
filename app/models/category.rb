class Category < ApplicationRecord
  belongs_to :user
  has_many :subcategories, dependent: :destroy
  has_many :expenses, dependent: :destroy
end
