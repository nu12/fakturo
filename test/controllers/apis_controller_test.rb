require "test_helper"

class ApisControllerTest < ActionDispatch::IntegrationTest
  test "should get empty total" do
    get total_api_url
    assert_response :success
    assert_equal([], response.parsed_body)
  end

  test "user one has expenses" do
    user = users(:one)
    get total_api_url(uuid: user.uuid, access_token: user.access_token)
    assert_response :success
    assert_not_equal([], response.parsed_body)
  end

  test "user two has disabled API access" do
    user = users(:two)
    get total_api_url(uuid: user.uuid, access_token: user.access_token)
    assert_response :success
    assert_equal([], response.parsed_body)
  end

  test "user three has expired access token" do
    user = users(:three)
    get total_api_url(uuid: user.uuid, access_token: user.access_token)
    assert_response :success
    assert_equal([], response.parsed_body)
  end
end
