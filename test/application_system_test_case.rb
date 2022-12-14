# frozen_string_literal: true

require "test_helper"
require 'capybara'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome
end
