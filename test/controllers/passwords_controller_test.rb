require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "edit" do
    get edit_user_password_path
    assert_response :success
  end

  test "update" do
    assert_changes -> { Current.user.reload.password_digest } do
      put password_path(Current.user), params: { password: "new", password_confirmation: "new" }
      assert_redirected_to edit_user_password_path
    end

    follow_redirect!
    assert_notice "Password has been reset"
  end

  test "update with non matching passwords" do
    token = Current.user.password_reset_token
    assert_no_changes -> { Current.user.reload.password_digest } do
      put password_path(token), params: { password: "no", password_confirmation: "match" }
      assert_redirected_to edit_user_password_path
    end

    follow_redirect!
    assert_notice "Passwords did not match"
  end

  private
    def assert_notice(text)
      assert_select "div", /#{text}/
    end
end
