# frozen_string_literal: true

# The DailyForecast class represents the forecast for a specific day.
#
# @example Creating a new DailyForecast
#   DailyForecast.new(date: Date.today, maximum_temperature: 23.5, precipitation_probability: 0.2)
class DailyForecast
  include ActiveModel::Model
  include ActiveModel::Attributes

  # @!attribute [r] date
  #   @return [Date] The date of the forecast.
  attribute :date, :date

  # @!attribute [r] maximum_temperature
  #   @return [Float] The maximum temperature for the day.
  attribute :maximum_temperature, :float

  # @!attribute [r] precipitation_probability
  #   @return [Float] The probability of precipitation for the day.
  attribute :precipitation_probability, :float

  validates :date, :maximum_temperature, :precipitation_probability, presence: true
end
