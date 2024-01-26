# frozen_string_literal: true

# Controller for managing weather forecasts
class WeatherForecastsController < ApplicationController
  # Show action for displaying weather forecast form
  def show
    @weather_forecast_command = WeatherForecastCommand.new
  end

  # Create action for creating weather forecast
  def create
    # This is potentially a long running operation, so we want to run it in a background job.
    # The UI could be updated with a simple polling mechanism that checks the status of the job,
    # or we could use ActionCable to push updates to the UI.
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
