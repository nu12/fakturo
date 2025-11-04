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
end
