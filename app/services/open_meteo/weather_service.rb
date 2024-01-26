# frozen_string_literal: true

module OpenMeteo
  # The Weather service is responsible for fetching weather forecast data from the Open-Meteo API.
  #
  # It uses the HTTParty gem to make HTTP requests and includes the base URI for the API.
  #
  # Example usage:
  #   weather_service = Services::Weather.new
  #   forecast = weather_service.forecast(52.52, 13.41)
  class WeatherService
    include HTTParty

    TEMPERATURE_UNIT = 'fahrenheit'
    DAILY_ATTRIBUTES = 'temperature_2m_max,precipitation_probability_max'

    base_uri 'api.open-meteo.com/v1'

    # Fetches the weather forecast for the given latitude and longitude.
    #
    # @param latitude [Float] the latitude for which to fetch the forecast
    # @param longitude [Float] the longitude for which to fetch the forecast
    # @return [HTTParty::Response] the API response
    def forecast(latitude, longitude)
      # In a real application, it might not be uncommon to have some additiopnal method arguments
      # to customize the API request query.
      query = {
        latitude:,
        longitude:,
        daily: DAILY_ATTRIBUTES,
        temperature_unit: TEMPERATURE_UNIT
      }

      self.class.get('/forecast', query:)
    end
  end
end
