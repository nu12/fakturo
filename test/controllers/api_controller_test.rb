require "test_helper"

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get all" do
    get api_all_url
    assert_response :forbidden
  end
end
