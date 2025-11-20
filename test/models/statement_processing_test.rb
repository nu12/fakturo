require "test_helper"

class StatementProcessingTest < ActiveSupport::TestCase
  test "create uuid before validation" do
    sp = StatementProcessing.create(user: users(:one), statement: statements(:upload), source: sources(:one))
    assert_not_equal(sp.uuid, nil)
  end
end
