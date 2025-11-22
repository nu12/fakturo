require "test_helper"

class StatementProcessingJobTest < ActiveJob::TestCase
  test "raw" do
    sp = statement_processings(:empty)
    assert_nil sp.raw
    # perform_enqueued_jobs do
    #   StatementProcessingJob.perform_later(sp)
    # end
    # assert_not_equal(sp.reload.raw,nil)
    # assert_equal(sp.statement.file.attached?,false)
  end
end
