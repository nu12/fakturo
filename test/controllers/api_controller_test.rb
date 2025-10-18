require "test_helper"

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get empty total" do
    get api_total_url
    assert_response :success
    assert_equal([], response.parsed_body)   
  end
end
