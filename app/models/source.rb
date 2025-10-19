class Source < ApplicationRecord
  belongs_to :user
  has_many :statements, dependent: :destroy
  has_many :expenses, through: :statements
end
