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
  class Helper
    def self.bootstrap
      user = User.create(username: "bootstrap", password: "123456")
      category = Category.create(name: "Bootstrap", user: user)
      subcategory = Subcategory.create(name: "Bootstrap", user: user, category: category)
      source = Source.create(name: "Bootstrap", user: user)
      statement = Statement.create(date: "2020-01-10", user: user, source: source)
      expense = Expense.create(date: "2020-01-01", raw_description: "autocat", description: "Bootstrap", user: user, statement: statement, category: category, subcategory: subcategory)
      return user, category, subcategory, source, statement, expense
    end
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
