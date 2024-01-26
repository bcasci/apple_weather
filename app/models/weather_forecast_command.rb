# The WeatherForecastCommand class is responsible for fetching and processing weather forecast data.
# It takes an address as an argument and uses a geocoding service to convert the address into coordinates.
# It then fetches the raw forecast data for those coordinates and processes it into a more convenient format.
#
# Example usage:
#   command = WeatherForecastCommand.new(address: '123 Main St')
#   command.run
#   forecasts = command.forecasts
#

class WeatherForecastCommand
  include ActiveModel::Model
  include ActiveModel::Attributes

  # Time after which a forecast is considered expired.
  EXPIRATION_TIME = 30.minutes.freeze

  # @!attribute [rw] address
  #   @return [String] the address for which to fetch the forecast
  attribute :address, :string

  # @!attribute [rw] success
  #   @return [Boolean] whether the last forecast fetch was successful
  attribute :success, :boolean

  # @!attribute [rw] new_forecast
  #   @return [Boolean] whether a new forecast was fetched live or out of the cache
  attribute :new_forecast, :boolean, default: false

  # @!attribute [rw] raw_forecast
  #   @return [Hash] the raw forecast data returned by the forecast API
  attribute :raw_forecast

  alias new_forecast? new_forecast

  validates :address, presence: true

  # Creates a new WeatherForecastCommand instance and runs it.
  # This is a convenience method that encapsulates the creation and running of a command.
  #
  # @param address [String] the address for which to fetch the forecast
  # @return [WeatherForecastCommand] the created and run command
  #
  # @example
  #   command = WeatherForecastCommand.create(address: '123 Main St')
  #
  def self.create(address:)
    command = new(address:)
    command.run
    command
  end

  # Runs the command. This method fetches the raw forecast data and sets the `raw_forecast` and `success` attributes.
  # The method will return early if the command is not valid (i.e., if the `address` attribute is not present).
  #
  # @return [nil, true, false]
  #
  # @example
  #   command = WeatherForecastCommand.new(address: '123 Main St')
  #   command.run
  #
  def run
    return unless valid?

    location = locate_address
    return unless location

    forecast = find_weather_forecast(location)
    log_forecast_problem(forecast) and return unless forecast

    self.raw_forecast = forecast
    self.success = true

    # In a real application, we might want to handle special exceptions
    # rescue => e
    #   ... log when appropriate ...
    #   ... handle when appropriate ...
    #   ... modoify return state when appropriate ...
    #   ... re-raise when appropriate ...
  end

  # Returns an array of DailyForecast objects, each representing the forecast for a single day.
  # If `raw_forecast` is not present (e.g., because `run` has not been called yet or because it encountered an error),
  # `forecasts` returns an empty array.
  #
  # @return [Array<DailyForecast>] An array of DailyForecast objects  
  def forecasts
    # Instance variabel caching may or may not be appropriate here, depending on the use case.
    return [] unless raw_forecast

    extract_daily_forecast_data.map do |date, maximum_temperature, precipitation_probability|
      DailyForecast.new(
        { date:, maximum_temperature:, precipitation_probability: }
      )
    end
  end

  private

  def extract_daily_forecast_data
    dates = raw_forecast['daily']['time']
    max_temps = raw_forecast['daily']['temperature_2m_max']
    precip_probs = raw_forecast['daily']['precipitation_probability_max']
    dates.zip(max_temps, precip_probs)   
  end

  def locate_address
    # In a real application, dependcy injection might be considered here
    geocode = Geocoder.search(address).first
    return geocode if geocode

    errors.add(:address, :address_not_found)
    nil
  end

  def find_weather_forecast(location)
    Rails.cache.fetch(location.postal_code, expires_in: EXPIRATION_TIME) do
      fetch_and_process_forecast(location)
    end
  end

  def fetch_and_process_forecast(location)
    forecast = OpenMeteo::WeatherService.new.forecast(location.latitude, location.longitude)
    self.new_forecast = true

    if forecast.success?
      # in a real application, we might want to do some additional processing of the forecast data,
      # or only cache a relevant subset of the data
      forecast.parsed_response
    else
      log_forecast_problem(forecast)
      nil
    end

    # In a real application, we might want to handle special exceptions
    # rescue OpenMeteo::WeatherService::ApiError => e
    #   handle_api_error(e)
  end

  def log_forecast_problem(forecast)
    # In a real application, we might want to log serious problems with the weather forecast
  end
end
