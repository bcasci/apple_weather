# Skills Assessment

This my skills assesment for Apple, Inc.

The goal is demonstrate that I can build a Rails application, and follow some requirements. My intention was not to produce a production worthy application.

There are comments throughout the code to indicate possible strategies that I might discuss with a team when building a bigger corporate/enterprise Rails appication.

-[Brandon](https://www.brandoncasci.com/resume.html)

```
brandoncasci$ rails test:all

# Running:

.......Rack::Handler is deprecated and replaced by Rackup::Handler
Capybara starting Puma...
* Version 6.4.2 , codename: The Eagle of Durango
* Min threads: 0, max threads: 4
* Listening on http://127.0.0.1:52619
................

Finished in 3.336514s, 6.8934 runs/s, 21.2797 assertions/s.
23 runs, 71 assertions, 0 failures, 0 errors, 0 skips
MacBook-Pro:apple_weather_alt brandoncasci$ 
```

## Requirements

- Must be done in Ruby on Rails
- Accept an address as input
- Retrieve forecast data for the given address. This should include, at minimum, the current temperature (Bonus points - Retrieve high/low and/or extended forecast)
- Display the requested forecast details to the user
- Cache the forecast details for 30 minutes for all subsequent requests by zip codes. Display indicator if result is pulled from cache.

## Assumptions

- This project is open to interpretation
- Functionality is a priority over form
- If you get stuck, complete as much as you can

## Submission

- Use a public source code repository (GitHub, etc) to store your code
- Send us the link to your completed code
