# frozen_string_literal: true

require 'application_system_test_case'

class WeatherForecastsTest < ApplicationSystemTestCase
  include WebMockHelpers::GeocoderStubs
  include WebMockHelpers::OpenMeteoStubs

  setup do
    @address = '197 Highland Ave, Somerville, MA'
    @postal_code = '02143'
    @latitude = 52.52
    @longitude = 13.41
    stub_geocoder_api(@postal_code, @latitude, @longitude)
    stub_open_meteo_api(@latitude, @longitude)
  end

  test 'successful creation of a weather forecast with a valid address' do
    command = WeatherForecastCommand.create(address: @address)

    visit root_path

    fill_in 'Address', with: @address
    click_on 'Get Forecast'

    assert_text command.class.human_attribute_name(
      "current_forecast.#{command.current_forecast}"
    )

    command.forecasts.each do |forecast|
      within("#daily_forecast_#{forecast.date.strftime('%A').downcase}") do
        assert_text forecast.date.strftime('%A')
        assert_text forecast.maximum_temperature
        assert_text forecast.precipitation_probability
      end
    end
  end

  test 'successful creation of a weather forecast when data is cached' do
    mem_cache_store = ActiveSupport::Cache.lookup_store(:memory_store)

    Rails.stub :cache, mem_cache_store do
      assert_nil Rails.cache.read(@postal_code)

      command = WeatherForecastCommand.create(address: @address)
      visit root_path

      fill_in 'Address', with: @address
      click_on 'Get Forecast'

      assert_text command.class.human_attribute_name('current_forecast.false')
    end
  end

  test 'weather forecast creation fails with an invalid address' do
    visit root_path

    fill_in 'Address', with: ''
    click_on 'Get Forecast'

    assert_text 'cannot be blank'
  end
end
