require "application_system_test_case"

class PasswordsTest < ApplicationSystemTestCase
setup do
    login_as(users(:one))
end
  test "change password" do
    visit edit_password_url

    fill_in "Password", with: "#R?741Y(S70}5.]11HVE<kzY!m|C015r%j7vi07eedn}BcAs22!2b1k"
    fill_in "Password confirmation", with: "#R?741Y(S70}5.]11HVE<kzY!m|C015r%j7vi07eedn}BcAs22!2b1k"

    click_on "Save"
    assert_content "Password has been reset"
  end

  test "change password with mismatch" do
    visit edit_password_url

    fill_in "Password", with: "match"
    fill_in "Password confirmation", with: "mismatch"

    click_on "Save"
    assert_content "Passwords did not match"
  end
end
