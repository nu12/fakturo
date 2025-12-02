class Subcategory < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :expenses, dependent: :destroy

  def update(params)
    if self.name_was == "Uncategorized"
      self.errors.add("This subcategory","cannot be changed")
      return false 
    end
    super params
  end

  def destroy!
    return false if self.name == "Uncategorized" && !destroyed_by_association
    super
  end
end
