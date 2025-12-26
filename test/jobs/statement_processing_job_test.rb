require "test_helper"

class StatementProcessingJobTest < ActiveJob::TestCase
  test "perform" do
    statement = Statement.new(source: sources(:one), user: users(:one), date: "2025-10-20")
    statement.file.attach(
      io: File.open("test/fixtures/files/faktura.pdf"),
      filename: "faktura.pdf",
      content_type: "application/pdf"
    )
    statement.save
    processing = StatementProcessing.create(user: users(:one), statement: statement, source: sources(:one))
    assert_nil processing.has_succeeded
    perform_enqueued_jobs do
      StatementProcessingJob.perform_later(processing, RpcClientStub)
    end
    assert_equal(true, processing.reload.has_succeeded)
    assert_equal(false, processing.statement.file.attached?)
    assert_equal(3, statement.reload.expenses.count)
  end
end
