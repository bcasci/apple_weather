
class DailyForecast
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :date, :date
  attribute :maximum_temperature, :float
  attribute :precipitation_probability, :float

  validates :date, :maximum_temperature, :precipitation_probability, presence: true
end
