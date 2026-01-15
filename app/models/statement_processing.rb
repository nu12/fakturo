class StatementProcessing < ApplicationRecord
  belongs_to :user
  belongs_to :source
  belongs_to :statement

  before_create :set_uuid

  def run
    StatementProcessingJob.perform_later self, Rpc::Client::StatementProcessingRpcClient
  end

  def retry
    unless self.statement.file.attached?
      errors.add :base, :invalid, message: "Statement file has already been deleted."
      return false
    end

    if self.has_succeeded
      errors.add :base, :invalid, message: "Statement has already been sucessfully processed."
      return false
    end
    update(has_succeeded: nil)
    run
  end

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
