require 'test_helper'

module OpenMeteo
  class WeatherServiceTest < ActiveSupport::TestCase
    include WebMockHelpers::OpenMeteoStubs

    def setup
      @latitude = 52.52
      @longitude = 13.41

      stub_open_meteo_api(@latitude, @longitude)
    end

    test 'fetches the weather forecast' do
      weather_service = OpenMeteo::WeatherService.new
      forecast = weather_service.forecast(
        @latitude,
        @longitude
      ).parsed_response

      assert_equal @latitude, forecast['latitude']
      assert_equal @longitude, forecast['longitude']
      assert_equal JSON.parse(open_meteo_api_time_result), forecast['daily']['time']
      assert_equal JSON.parse(open_meteo_api_temp_max_result), forecast['daily']['temperature_2m_max']
      assert_equal JSON.parse(open_meteo_api_precip_prob_result), forecast['daily']['precipitation_probability_max']
    end
  end
end

