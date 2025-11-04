require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  private 
  def login_as_user_one
    visit new_session_path
    fill_in "Username", with: "one"
    fill_in "Password", with: "password"
    click_on "Sign in"

    click_on "Home"
  end
end
