require "test_helper"

class ApisControllerTest < ActionDispatch::IntegrationTest
  test "should get empty total" do
    get total_api_path
    assert_response :success
    assert_equal([], response.parsed_body)
  end
end
