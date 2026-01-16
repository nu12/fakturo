require "test_helper"

class StatementProcessingTest < ActiveSupport::TestCase
  test "create uuid before validation" do
    processing = StatementProcessing.create(user: users(:one), statement: statements(:upload), source: sources(:one))
    assert_not_equal(processing.uuid, nil)
  end

  test "run" do
    processing = StatementProcessing.create(user: users(:one), statement: statements(:upload), source: sources(:one))
    assert_equal(StatementProcessingJob, processing.run.class)
  end

  test "retry" do
    processing = StatementProcessing.create(user: users(:one), statement: statements(:upload), source: sources(:one))
    processing.statement.file.attach(
      io: File.open("test/fixtures/files/faktura.pdf"),
      filename: "faktura.pdf",
      content_type: "application/pdf"
    )
    assert_equal(StatementProcessingJob, processing.retry.class)
  end

  test "retry with deleted file" do
    processing = StatementProcessing.create(user: users(:one), statement: statements(:upload), source: sources(:one))
    assert_equal(false, processing.retry)
    assert_equal("Statement file has already been deleted.", processing.errors.first.message)
  end

  test "retry with completed processing" do
    processing = StatementProcessing.create(user: users(:one), statement: statements(:upload), source: sources(:one), has_succeeded: true)
    processing.statement.file.attach(
      io: File.open("test/fixtures/files/faktura.pdf"),
      filename: "faktura.pdf",
      content_type: "application/pdf"
    )
    assert_equal(false, processing.retry)
    assert_equal("Statement has already been sucessfully processed.", processing.errors.first.message)
  end
end
