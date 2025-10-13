require "test_helper"

class GuestControllerTest < ActionDispatch::IntegrationTest
  test "should get policy" do
    get policy_url
    assert_response :success
  end
end
