# frozen_string_literal: true

require 'test_helper'

class WeatherForecastsControllerTest < ActionDispatch::IntegrationTest
  include WebMockHelpers::GeocoderStubs
  include WebMockHelpers::OpenMeteoStubs

  setup do
    postal_code = '02143'
    latitude = 52.52
    longitude = 13.41
    stub_geocoder_api(postal_code, latitude, longitude)
    stub_open_meteo_api(latitude, longitude)
  end

  test 'show action responds successfully' do
    get weather_forecast_path
    assert_response :success
  end

  test 'create action successfully creates a new weather forecast' do
    post weather_forecast_path, params: { weather_forecast: { address: '197 Highland Ave, Somervile, MA' } },
                                xhr: true
    assert_response :success
  end

  test 'create action returns unprocessable_entity when address is not valid' do
    post weather_forecast_path, params: { weather_forecast: { address: '' } },
                                xhr: true
    assert_response :unprocessable_entity
  end
end
