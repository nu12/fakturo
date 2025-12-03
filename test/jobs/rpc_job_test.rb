require "test_helper"

class RpcJobTest < ActiveJob::TestCase
  test "result" do
    sp = StatementProcessing.create(user: users(:one), statement: statements(:one), source: sources(:one), raw: "")
    assert_nil sp.result
    perform_enqueued_jobs do
      RpcJob.perform_later(sp, RpcClientStub, false)
    end
    assert_equal("[]", sp.reload.result)
    assert_nil sp.reload.raw
  end
end
