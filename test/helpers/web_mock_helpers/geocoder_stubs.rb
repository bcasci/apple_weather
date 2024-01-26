module WebMockHelpers
  module GeocoderStubs
    def stub_empty_geocoder_api_result
      stub_request(
        :get,
        %r{https://nominatim.openstreetmap.org/search\?.*q=.*}
      ).to_return(
        body: '[]',
        status: 200,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def stub_geocoder_api(postal_code, latitude, longitude)
      stub_request(
        :get,
        %r{https://nominatim.openstreetmap.org/search\?.*q=.*}
      ).to_return(
        body: geocoder_api_result(postal_code, latitude, longitude),
        status: 200,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    private

    def geocoder_api_result(postal_code, latitude, longitude)
      <<-JSON
        [
          {
            "place_id": 17884924,
            "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
            "osm_type": "way",
            "osm_id": 29683274,
            "lat": #{latitude.to_s},
            "lon": #{longitude.to_s},
            "class": "building",
            "type": "detached",
            "place_rank": 30,
            "importance": 9.99999999995449e-06,
            "addresstype": "building",
            "name": "",
            "display_name": "197, Highland Avenue, Spring Hill, Somerville, Middlesex County, Massachusetts, 02143, United States",
            "address": {
              "house_number": "197",
              "road": "Highland Avenue",
              "neighbourhood": "Spring Hill",
              "city": "Somerville",
              "county": "Middlesex County",
              "state": "Massachusetts",
              "ISO3166-2-lvl4": "US-MA",
              "postcode": "#{postal_code}",
              "country": "United States",
              "country_code": "us"
            },
            "boundingbox": [
              "42.3896977",
              "42.3898499",
              "-71.1065737",
              "-71.1064222"
            ]
          }
        ]
      JSON
    end
  end
end
