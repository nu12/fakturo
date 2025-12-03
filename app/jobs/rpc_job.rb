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

  class StatementProcessingRPCClient
    attr_accessor :call_id, :response, :lock, :condition, :connection,
                  :channel, :server_queue_name, :reply_queue, :exchange

    def initialize(server_queue_name)
      @connection = Bunny.new(automatically_recover: false)
      @connection.start

      @channel = connection.create_channel
      @exchange = channel.default_exchange
      @server_queue_name = server_queue_name

      setup_reply_queue
    end

    def call(sp)
      @call_id = sp.uuid

      exchange.publish(sp.raw,
                      routing_key: server_queue_name,
                      correlation_id: call_id,
                      reply_to: reply_queue.name)

      # wait for the signal to continue the execution
      lock.synchronize { condition.wait(lock) }

      response
    end

    def stop
      channel.close
      connection.close
    end

    private

    def setup_reply_queue
      @lock = Mutex.new
      @condition = ConditionVariable.new
      that = self
      @reply_queue = channel.queue("", exclusive: true)

      reply_queue.subscribe do |_delivery_info, properties, payload|
        if properties[:correlation_id] == that.call_id
          that.response = payload

          # sends the signal to continue the execution of #call
          that.lock.synchronize { that.condition.signal }
        end
      end
    end
  end
end
