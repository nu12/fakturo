require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_registration_path
    assert_response :success
  end

  test "create with valid credentials" do
    post registration_path(username: "register", password: "password", password_confirmation: "password")
    assert_response :found
  end

  test "create with invalid credentials" do
    post registration_path(username: "register", password: "password", password_confirmation: "wrong")
    assert_response :unprocessable_content
  end

  test "delete" do
    sign_in_as users(:one)
    get delete_registration_path
    assert_response :success
  end

  test "destroy" do
    delete registration_path
    assert_redirected_to new_session_path
  end
end
