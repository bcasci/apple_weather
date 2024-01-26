ENV["RAILS_ENV"] ||= "test"
require 'minitest/autorun'
require_relative "../config/environment"
require "rails/test_help"
require 'webmock/minitest'
require_relative 'helpers/web_mock_helpers/open_meteo_stubs'
require_relative 'helpers/web_mock_helpers/geocoder_stubs'

WebMock.disable_net_connect!(allow_localhost: true)

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
