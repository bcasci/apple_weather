# frozen_string_literal: true

# Controller for managing weather forecasts
class WeatherForecastsController < ApplicationController
  # Show action for displaying weather forecast form
  def show
    @weather_forecast_command = WeatherForecastCommand.new
  end

  # Create action for creating weather forecast
  def create
    @weather_forecast_command = WeatherForecastCommand.create(**weather_forecast_params)

    render :show, status: :unprocessable_entity unless @weather_forecast_command.success?

    @forecasts = @weather_forecast_command.forecasts
  end

  private

  # Strong parameters for weather forecast
  def weather_forecast_params
    params.require(:weather_forecast).permit(:address).to_hash.symbolize_keys
  end
end
