class StatementProcessing < ApplicationRecord
  belongs_to :user
  belongs_to :source
  belongs_to :statement
  has_encrypted :raw

  before_create :set_uuid

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
