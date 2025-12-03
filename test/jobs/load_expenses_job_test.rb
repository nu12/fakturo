require "test_helper"

class LoadExpensesJobTest < ActiveJob::TestCase
  test "expenses" do
    s = Statement.new(source: sources(:one), user: users(:one), date: "2025-10-20")
    sp = StatementProcessing.create(user: users(:one), statement: s, source: sources(:one), result: "[{\"date\": \"2025-09-01\", \"description\": \"A\", \"value\": 10.10},{\"date\": \"2025-09-01\", \"description\": \"B\", \"value\": 10.10},{\"date\": \"2025-09-01\", \"description\": \"C\", \"value\": 10.10}]")
    perform_enqueued_jobs do
      LoadExpensesJob.perform_later(sp)
    end
    assert_equal(3, s.reload.expenses.count)
    assert_nil sp.reload.result
  end
end
