require "test_helper"

class ApiAccessControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "edit" do
    get edit_api_access_path
    assert_response :success
  end

  test "update" do
    put api_access_path
    assert_response :found
    assert_redirected_to edit_api_access_path
  end

  test "toogle" do
    put toogle_api_access_path
    assert_response :found
    assert_redirected_to edit_api_access_path
  end
end
