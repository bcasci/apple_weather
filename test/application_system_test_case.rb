# frozen_string_literal: true

require 'test_helper'

require 'capybara/cuprite'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite, using: :chrome, screen_size: [1920, 1080]

  Capybara.javascript_driver = :cuprite
  Capybara.register_driver(:cuprite) do |app|
    Capybara::Cuprite::Driver.new(app, window_size: [1200, 800])
  end
end
