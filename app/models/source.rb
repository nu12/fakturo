class Source < ApplicationRecord
  belongs_to :user
  has_many :statements, dependent: :delete_all
  has_many :expenses, through: :statements

  before_destroy :destroy_statements, prepend: true

  private

  def destroy_statements
    self.statements.each { |d| d.destroy! }
  end
end
