class Category < ApplicationRecord
  belongs_to :user
  has_many :subcategories, dependent: :delete_all
  has_many :expenses, through: :subcategories

  before_destroy :destroy_subcategories, prepend: true

  private

  def destroy_subcategories
    self.subcategories.each {|d| d.destroy!}
  end

end
