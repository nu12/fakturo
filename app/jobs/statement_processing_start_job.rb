# This job is the entrypoint for the statement processing chain
class StatementProcessingStartJob < ApplicationJob
  queue_as :default

  def perform(sp)
  end
end
