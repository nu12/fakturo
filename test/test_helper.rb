ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helpers/session_test_helper"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    # parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

class RpcClientStub
  def initialize(server_queue_name)
  end
  def call(sp, content)
    "[{\"date\": \"2025-09-01\", \"description\": \"A\", \"value\": 10.10},{\"date\": \"2025-09-01\", \"description\": \"B\", \"value\": 10.10},{\"date\": \"2025-09-01\", \"description\": \"C\", \"value\": 10.10}]"
  end
  def stop
  end
end
