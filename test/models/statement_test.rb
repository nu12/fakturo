require "test_helper"

class StatementTest < ActiveSupport::TestCase
  test "statement value sum" do
    s = Statement.new
    s.expenses << Expense.new(value: 10.10)
    s.expenses << Expense.new(value: 2.22)
    s.expenses << Expense.new(value: 9.99, ignore: true)
    assert_equal(s.value, 12.32)
  end

  test "extract year and month from date" do
    s = Statement.create(source: sources(:one), user: users(:one), date: "2025-10-20")
    assert_equal(s.month, 10)
    assert_equal(s.year, 2025)
  end

  test "is_upload" do
    s = Statement.new(source: sources(:one), user: users(:one), date: "2025-10-20")
    s.file.attach(
      io: File.open("test/fixtures/files/faktura.pdf"),
      filename: "faktura.pdf",
      content_type: "application/pdf"
    )
    s.save
    assert_equal(s.is_upload, true)

    s.file.purge
    s.save
    assert_equal(s.is_upload, true)
  end
end
