class WeatherForecastsController < ApplicationController
  def show
    @weather_forecast_command = WeatherForecastCommand.new
  end

  def create
    @weather_forecast_command = WeatherForecastCommand.create(**weather_forecast_params)

    render :show, status: :unprocessable_entity unless @weather_forecast_command.success?

    @forecasts = @weather_forecast_command.forecasts
  end

  private

  def weather_forecast_params
    params.require(:weather_forecast).permit(:address).to_hash.symbolize_keys
  end
end
