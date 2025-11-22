class Statement < ApplicationRecord
  belongs_to :source
  belongs_to :user
  has_many :expenses, dependent: :destroy
  has_one :statement_processing, dependent: :destroy
  has_one_attached :file
  encrypts_attached :file

  default_scope { order(year: :asc, month: :asc, source_id: :asc) }

  before_create :set_is_upload
  before_save :set_month_and_year
  validate :document_mime_type

  def value
    self.expenses.select { |e| !e[:ignore] }.collect { |k, v| k[:value] }.sum
  end

  private
  def set_is_upload
    self.is_upload = self.file.attached?
  end

  def set_month_and_year
    self.month = self.date.month
    self.year = self.date.year
  end

  def document_mime_type
    if self.file.attached? && !self.file.content_type.in?(%w[application/pdf])
      errors.add(:file, "Must be a PDF")
    end
  end
end
