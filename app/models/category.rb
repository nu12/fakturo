class Category < ApplicationRecord
  belongs_to :user
  has_many :subcategories, dependent: :destroy
  has_many :expenses, dependent: :destroy

  def update(params)
    if self.name_was == "Uncategorized"
      self.errors.add("This category", "cannot be changed")
      return false
    end
    super params
  end

  def update(params)
    if self.name_was == "Uncategorized"
      self.errors.add("This category", "cannot be changed")
      return false
    end
    super params
  end

  def destroy!
    return false if self.name == "Uncategorized" && !destroyed_by_association
    super
  end
end
