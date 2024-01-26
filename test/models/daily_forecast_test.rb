# frozen_string_literal: true

require 'test_helper'

class DailyForecastTest < ActiveSupport::TestCase
  setup do
    @forecast = DailyForecast.new(date: Date.today, maximum_temperature: 30.5, precipitation_probability: 50)
  end

  test 'valid forecast' do
    assert @forecast.valid?
  end

  test 'invalid without date' do
    @forecast.date = nil
    assert @forecast.invalid?
    assert @forecast.errors.of_kind?(:date, :blank)
  end

  test 'invalid without maximum_temperature' do
    @forecast.maximum_temperature = nil
    assert @forecast.invalid?
    assert @forecast.errors.of_kind?(:maximum_temperature, :blank)
  end

  test 'invalid without precipitation_probability' do
    @forecast.precipitation_probability = nil
    assert @forecast.invalid?
    assert @forecast.errors.of_kind?(:precipitation_probability, :blank)
  end

  test '#to_key returns array with weekday name when date is present' do
    assert_equal [@forecast.date.strftime('%A').downcase], @forecast.to_key
  end

  test '#to_key returns nil date is not present' do
    @forecast.date = nil
    assert_nil @forecast.to_key
  end
end
