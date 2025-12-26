require "test_helper"

class StatementTest < ActiveSupport::TestCase
  test "statement value sum" do
    statement = Statement.new
    statement.expenses << Expense.new(value: 10.10)
    statement.expenses << Expense.new(value: 2.22)
    statement.expenses << Expense.new(value: 9.99, ignore: true)
    assert_equal(statement.value, 12.32)
  end

  test "extract year and month from date" do
    statement = Statement.create(source: sources(:one), user: users(:one), date: "2025-10-20")
    assert_equal(statement.month, 10)
    assert_equal(statement.year, 2025)
  end

  test "is_upload" do
    statement = Statement.new(source: sources(:one), user: users(:one), date: "2025-10-20")
    statement.file.attach(
      io: File.open("test/fixtures/files/faktura.pdf"),
      filename: "faktura.pdf",
      content_type: "application/pdf"
    )
    statement.save
    assert_equal(statement.is_upload, true)

    statement.file.purge
    statement.save
    assert_equal(statement.is_upload, true)
  end

  test "validate content type" do
    statement = Statement.new(source: sources(:one), user: users(:one), date: "2025-10-20")

    statement.file.attach(
      io: File.open("test/fixtures/files/faktura.pdf"),
      filename: "faktura.pdf",
      content_type: "application/pdf"
    )
    assert_equal(statement.valid?, true)

    statement.file.attach(
      io: File.open("app/assets/images/logo.png"),
      filename: "logo.png",
      content_type: "image/png"
    )
    assert_equal(statement.valid?, false)
  end
end
