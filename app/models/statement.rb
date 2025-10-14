class Statement < ApplicationRecord
  belongs_to :source
  belongs_to :user

  has_many :expenses, dependent: :delete_all
end
