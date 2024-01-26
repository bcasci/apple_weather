require 'test_helper'

class WeatherForecastCommandTest < ActiveSupport::TestCase
  include WebMockHelpers::GeocoderStubs
  include WebMockHelpers::OpenMeteoStubs

  # In a real applicaiton, we might also trigger certain exceptions and test their handling
  # but for demonstration purposes, this is being kept simple and testing happy paths and
  # basic failure logic.

  def setup
    @address = '197 Highland Avvenue, Somerville, MA'
    @latitude = 52.52
    @longitude = 13.41
    @postal_code = '02143'
  end

  test 'validates presence of address' do
    command = WeatherForecastCommand.new
    assert command.invalid?
    assert command.errors.of_kind?(:address, :blank)
  end

  test '.create calls .new(...).run' do
    command = Minitest::Mock.new
    command.expect(:run, nil)

    WeatherForecastCommand.stub :new, command do
      WeatherForecastCommand.create(address: 'valid address')
    end
    assert_mock command
  end

  test '#current_forecast? aliases #current_forecast' do
    command = WeatherForecastCommand.new(current_forecast: true)
    assert_equal command.current_forecast, command.current_forecast?
  end

  test '#forecasts returns an array of DailyForecast objects' do
    raw_forecast_data = {
      'daily' => {
        'time' => %w[2022-01-01 2022-01-02],
        'temperature_2m_max' => [20, 22],
        'precipitation_probability_max' => [10, 20]
      }
    }

    command = WeatherForecastCommand.new(address: 'valid address')
    command.stub :raw_forecast, raw_forecast_data do
      forecasts = command.forecasts
      assert_equal 2, forecasts.size

      2.times do |i|
        forecasts[i].tap do |forecast|
          assert_instance_of DailyForecast, forecast
          assert_equal Date.parse(raw_forecast_data['daily']['time'][i]),
                       forecast.date
          assert_equal raw_forecast_data['daily']['temperature_2m_max'][i],
                       forecast.maximum_temperature
          assert_equal raw_forecast_data['daily']['precipitation_probability_max'][i],
                       forecast.precipitation_probability
        end
      end
    end
  end

  test '#model_name provides correct param_key, route_key, and singular_route_key' do
    model_name = WeatherForecastCommand.model_name
    assert_equal 'weather_forecast', model_name.param_key
    assert_equal 'weather_forecasts', model_name.route_key
    assert_equal 'weather_forecast', model_name.singular_route_key
  end

  test '#run successfully executes with a valid address' do
    stub_geocoder_api(@postal_code, @latitude, @longitude)
    stub_open_meteo_api(@latitude, @longitude)
    parsed_api_result = JSON.parse(open_meteo_api_result(@latitude, @longitude))

    command = WeatherForecastCommand.new(address: @address)
    command.run

    assert command.valid?
    assert_equal parsed_api_result, command.raw_forecast
    assert_equal parsed_api_result['daily']['time'].size, command.forecasts.size
  end

  test '#run fails without an address' do
    command = WeatherForecastCommand.new(address: nil)
    command.run

    assert command.invalid?
    assert_nil command.raw_forecast
  end

  test '#run fails with an invalid address' do
    stub_empty_geocoder_api_result
    command = WeatherForecastCommand.new(address: 'Invalid Address')
    command.run

    assert command.errors.of_kind?(:address, :address_not_found)
    assert_not command.success
    assert_nil command.raw_forecast
  end

  test '#success? aliases #success' do
    command = WeatherForecastCommand.new(success: true)
    assert_equal command.success, command.success?
  end

  test 'weather forecast is cached' do
    # Depending on the nature of the applicaiton, the cache store might be specified
    # by dependency injection to the test subject

    mem_cache_store = ActiveSupport::Cache.lookup_store(:memory_store)

    stub_geocoder_api(@postal_code, @latitude, @longitude)
    stub_open_meteo_api(@latitude, @longitude)

    Rails.stub :cache, mem_cache_store do
      # first run should not be cached
      assert_nil Rails.cache.read(@postal_code)

      command = WeatherForecastCommand.create(address: @address)

      assert command.current_forecast?

      # second run should be cached

      Rails.cache.write(
        @postal_code,
        { 'source' => 'cache' }.merge(command.raw_forecast)
      )
      command = WeatherForecastCommand.create(address: @address)

      assert_not command.current_forecast?
      assert_equal 'cache', command.raw_forecast['source']
    end
  end
end
