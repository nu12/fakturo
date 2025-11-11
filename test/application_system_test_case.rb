require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  private
  def login_as(user)
    visit new_session_url
    fill_in "username", with: user.username
    fill_in "password", with: "#R?741Y(S70}5.]11HVE<kzY!m|C015r%j7vi07eedn}BcAs22!2b1k"
    click_on "Sign in"
    assert_no_text "Sign in"
  end
end
