require 'test_helper'

module OpenMeteo
  class WeatherServiceTest < ActiveSupport::TestCase
    # In a real applicaiton, there might be ay combination of file fixtures, VCR cassettes
    # helpers methods and factories to create stubbed api responses. = 
    LATITUDE = 52.52
    LONGITUDE = 13.41
    API_TIME_RESULT = '["2024-01-25", "2024-01-26", "2024-01-27", "2024-01-28", "2024-01-29", "2024-01-30", "2024-01-31"]'
                      .freeze
    API_TEMP_MAX_RESULT = '[45.0, 48.6, 41.7, 40.3, 45.7, 46.6, 49.6]'.freeze
    API_PRECIP_PROB_RESULT = '[23, 100, 0, 0, 10, 6, 16]'.freeze
    API_RESULT = <<~JSON.freeze
      {
        "latitude": #{LATITUDE},
        "longitude": #{LONGITUDE},
        "generationtime_ms": 0.11301040649414062,
        "utc_offset_seconds": 0,
        "timezone": "GMT",
        "timezone_abbreviation": "GMT",
        "elevation": 38.0,
        "daily_units": {
          "time": "iso8601",
          "temperature_2m_max": "°F",
          "precipitation_probability_max": "%"
        },
        "daily": {
          "time": #{API_TIME_RESULT},
          "temperature_2m_max": #{API_TEMP_MAX_RESULT},
          "precipitation_probability_max": [23, 100, 0, 0, 10, 6, 16]
        }
      }
    JSON

    def setup
      stub_request(:get, /api.open-meteo.com/)
        .to_return(
          body: API_RESULT,
          status: 200,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    test 'fetches the weather forecast' do
      weather_service = OpenMeteo::WeatherService.new
      forecast = weather_service.forecast(
        LATITUDE,
        LONGITUDE
      ).parsed_response

      assert_equal LATITUDE, forecast['latitude']
      assert_equal LONGITUDE, forecast['longitude']
      assert_equal JSON.parse(API_TIME_RESULT), forecast['daily']['time']
      assert_equal JSON.parse(API_TEMP_MAX_RESULT), forecast['daily']['temperature_2m_max']
      assert_equal JSON.parse(API_PRECIP_PROB_RESULT), forecast['daily']['precipitation_probability_max']
    end
  end
end

