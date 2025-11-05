require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips username" do
    user = User.new(username: " USERNAME ")
    assert_equal("username", user.username)
  end

  test "create uuid before validation" do
    user = User.create(username: "create_uuid", password: "password")
    assert user.uuid != nil
    assert user.access_token != nil
  end

  test "regenerate access token" do
    user = User.create(username: "create_uuid", password: "password")
    user.regenerate_token
    previous_token = user.access_token
    user.regenerate_token
    assert user.access_token != previous_token
  end
end
