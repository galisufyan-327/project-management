require "test_helper"
require 'capybara'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome

  def sign_in(email, password: 'password')
    visit new_user_session_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password

    click_button 'Log in'
  end
end
