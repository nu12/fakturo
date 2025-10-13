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
end
