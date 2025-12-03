require "test_helper"

class StatementProcessingJobTest < ActiveJob::TestCase
  test "raw" do
    s = Statement.new(source: sources(:one), user: users(:one), date: "2025-10-20")
    s.file.attach(
      io: File.open("test/fixtures/files/faktura.pdf"),
      filename: "faktura.pdf",
      content_type: "application/pdf"
    )
    s.save
    sp = StatementProcessing.create(user: users(:one), statement: s, source: sources(:one))
    assert_nil sp.raw
    perform_enqueued_jobs do
      StatementProcessingJob.perform_later(sp, nil, false)
    end
    assert_not_equal(sp.reload.raw, nil)
    assert_equal(sp.statement.file.attached?, false)
  end
end
