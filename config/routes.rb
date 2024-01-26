Rails.application.routes.draw do
  resource :weather_forecast, only: %i[show create]
  # This helps form_for find the correct route when resources are singular
  resolve("WeatherForecastCommand") { [:weather_forecast] }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "weather_forecasts#show"
end
