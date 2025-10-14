require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "create uuid before validation" do
    user = User.new
    user.save
    assert user.uuid != nil
  end

  test "regenerate access token" do
    user = User.new
    user.save
    user.regenerate_token
    previous_token = user.access_token
    user.regenerate_token
    assert user.access_token != previous_token
  end
end
