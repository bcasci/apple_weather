require 'application_system_test_case'

class WeatherForecastsTest < ApplicationSystemTestCase
  include WebMockHelpers::GeocoderStubs
  include WebMockHelpers::OpenMeteoStubs

  setup do
    postal_code = '02143'
    latitude = 52.52
    longitude = 13.41
    stub_geocoder_api(postal_code, latitude, longitude)
    stub_open_meteo_api(latitude, longitude)
  end
  
  test 'creating a weather forecast - happy path' do
    visit root_path

    fill_in 'Address', with: '197 Highland Ave, Somerville, MA'
    click_on 'Get Forecast'

    assert_text 'Weather forecast was successfully created.'
  end

  test 'creating a weather forecast - sad path' do
    visit root_path

    fill_in 'Address', with: ''
    click_on 'Get Forecast'

    assert_text 'cannot be blank'
  end
end
