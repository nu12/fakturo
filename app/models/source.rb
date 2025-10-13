class Source < ApplicationRecord
  belongs_to :user
  has_many :documents, dependent: :delete_all
  has_many :expenses, through: :documents

  before_destroy :destroy_documents, prepend: true

  private

  def destroy_documents
    self.documents.each { |d| d.destroy! }
  end
end
