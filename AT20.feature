Feature: Geolocated seven-day weather forecast query (Telemetry)
  As a Client Application Developer
  I want to request weather forecast data for the plot centroid coordinate
  so I can alert the producer about heatwaves, frost or desiccating winds

  # Escenario 1: Entrega de pronóstico geolocalizado
  Scenario Outline: Geolocated weather forecast delivery
    Given a GET request to "/api/v1/plots/<plotId>/forecasts" with authorized token
    When the API resolves the plot centroid and obtains the 7-day forecast from external service with 3-hour cache
    Then the response status is 200
    And the response returns "ForecastResource" with max and min temperatures, precipitation probability, wind speed and timestamp

    Examples:
      | plotId            | centroidLat | centroidLon |
      | plot-jeronomo-001 | -18.0550    | -70.2450    |

  # Escenario 2: Parcela sin geometría definida
  Scenario Outline: Plot without defined spatial geometry
    Given a GET request directed to a plot without valid boundary coordinates: "<plotId>"
    When the API attempts to calculate the geographic centroid
    Then the response status is 400
    And the response indicates absence of georeferencing

    Examples:
      | plotId             |
      | plot-no-polygon-03 |
