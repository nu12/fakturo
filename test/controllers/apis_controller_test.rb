require "test_helper"

class ApisControllerTest < ActionDispatch::IntegrationTest
  test "should have parameters" do
    get total_api_url
    assert_response :bad_request
  end

  test "user one has expenses" do
    user = users(:one)
    get total_api_url(user: {uuid: user.uuid, access_token: user.access_token}, format: :json)
    assert_response :success
    assert_not_equal([], response.parsed_body)

    get total_api_url(user: {uuid: user.uuid, access_token: user.access_token}, format: :csv)
    assert_response :success
    assert_not_equal("", response.parsed_body)
  end

  test "user two has disabled API access" do
    user = users(:two)
    get total_api_url(user: {uuid: user.uuid, access_token: user.access_token}, format: :json)
    assert_response :success
    assert_equal([], response.parsed_body)

    get total_api_url(user: {uuid: user.uuid, access_token: user.access_token}, format: :csv)
    assert_response :success
    assert_equal("", response.parsed_body)
  end

  test "user three has expired access token" do
    user = users(:three)
    get total_api_url(user: {uuid: user.uuid, access_token: user.access_token}, format: :json)
    assert_response :success
    assert_equal([], response.parsed_body)

    get total_api_url(user: {uuid: user.uuid, access_token: user.access_token}, format: :csv)
    assert_response :success
    assert_equal("", response.parsed_body)
  end

  test "monthly" do
    user = users(:one)
    get monthly_api_url(user: {uuid: user.uuid, access_token: user.access_token}, format: :json)
    assert_response :success
    assert_not_equal([], response.parsed_body)

    get monthly_api_url(user: {uuid: user.uuid, access_token: user.access_token}, format: :csv)
    assert_response :success
    assert_not_equal("", response.parsed_body)
  end
end
