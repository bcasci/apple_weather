class WeatherForecastCommand
  include ActiveModel::Model
  include ActiveModel::Attributes

  EXPIRATION_TIME = 30.minutes.freeze

  attribute :address, :string
  attribute :success, :boolean, default: false
  attribute :new_forecast, :boolean, default: false
  attribute :raw_forecast

  alias new_forecast? new_forecast

  validates :address, presence: true

  def self.create(address:)
    new(address:).tap(&:run)
  end

  def run
    return unless valid?

    location = locate_address
    return unless location

    forecast = find_weather_forecast(location)
    log_forecast_problem(forecast) and return unless forecast

    self.raw_forecast = forecast
    self.success = true
  end

  private

  def locate_address
    geocode = Geocoder.search(address).first
    return geocode if geocode

    errors.add(:base, :address_not_found)
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
