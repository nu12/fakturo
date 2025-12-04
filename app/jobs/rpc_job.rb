require "bunny"
require "thread"

class RpcJob < ApplicationJob
  queue_as :default

  def perform(sp, rpc_client, cascade = true)
    p "Start RPC job for #{sp.uuid}"
    client = rpc_client.new("rpc_queue")
    response = client.call(sp)
    client.stop
    LoadExpensesJob.perform_later(sp) if sp.update(result: response, raw: nil) && cascade
  end
end
