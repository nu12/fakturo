require "application_system_test_case"

class RegistrationsTest < ApplicationSystemTestCase
  test "new registration" do
    user = users(:one)
    visit new_registration_url

    fill_in "Username", with: "reg"
    fill_in "Password", with: "#R?741Y(S70}5.]11HVE<kzY!m|C015r%j7vi07eedn}BcAs22!2b1k"
    fill_in "Password confirmation", with: "#R?741Y(S70}5.]11HVE<kzY!m|C015r%j7vi07eedn}BcAs22!2b1k"

    click_on "Sign up"
    assert_content "User registred successfully"
  end

  test "delete registration" do
    login_as(users(:one))
    visit delete_registration_url

    click_on "I wish to proceed and erase all my data"
    assert_content "You will not be prompted to confirm after clicking in the button below. Proceed with caution."
    click_on "Erase everything"
  end
end
