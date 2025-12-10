require "test_helper"

class StatementProcessingJobTest < ActiveJob::TestCase
  test "perform" do
    s = Statement.new(source: sources(:one), user: users(:one), date: "2025-10-20")
    s.file.attach(
      io: File.open("test/fixtures/files/faktura.pdf"),
      filename: "faktura.pdf",
      content_type: "application/pdf"
    )
    s.save
    sp = StatementProcessing.create(user: users(:one), statement: s, source: sources(:one))
    assert_nil sp.has_succeeded
    perform_enqueued_jobs do
      StatementProcessingJob.perform_later(sp, RpcClientStub)
    end
    assert_equal(true, sp.reload.has_succeeded)
    assert_equal(false, sp.statement.file.attached?)
    assert_equal(3, s.reload.expenses.count)
  end
end
