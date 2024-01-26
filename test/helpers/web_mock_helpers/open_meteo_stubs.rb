# The WebMockHelpers::OpenMeteoStubs module provides helper methods for stubbing
# the Open Meteo API in tests. It includes methods for generating stubbed responses
# for the API's time, maximum temperature, and precipitation probability results.
# It also includes a method for stubbing the API request itself.
#
# Example usage:
#   class WeatherServiceTest < ActiveSupport::TestCase
#     include WebMockHelpers::OpenMeteoStubs
#
#     def setup
#       @latitude = 52.52
#       @longitude = 13.41
#       stub_open_meteo_api(@latitude, @longitude)
#     end
#
#     # ...
#   end
module WebMockHelpers
  module OpenMeteoStubs
    def open_meteo_api_time_result
      '["2024-01-25", "2024-01-26", "2024-01-27", "2024-01-28", "2024-01-29", "2024-01-30", "2024-01-31"]'
    end

    def open_meteo_api_temp_max_result
      '[45.0, 48.6, 41.7, 40.3, 45.7, 46.6, 49.6]'
    end

    def open_meteo_api_precip_prob_result
      '[23, 100, 0, 0, 10, 6, 16]'
    end

    def stub_open_meteo_api(latitude, longitude)
      stub_request(:get, /api.open-meteo.com/)
        .to_return(
          body: open_meteo_api_result(latitude, longitude),
          status: 200,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    def open_meteo_api_result(latitude, longitude)
      <<-JSON
        {
          "latitude": #{latitude},
          "longitude": #{longitude},
          "generationtime_ms": 0.048995018005371094,
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
            "time": #{open_meteo_api_time_result},
            "temperature_2m_max": #{open_meteo_api_temp_max_result},
            "precipitation_probability_max": #{open_meteo_api_precip_prob_result}
          }
        }
      JSON
    end
  end
end
