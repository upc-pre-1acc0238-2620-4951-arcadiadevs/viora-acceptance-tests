Feature: Environmental and soil telemetry time-series query (Telemetry)
  As a Client Application Developer
  I want to request hourly microclimate and soil moisture readings from the API
  so I can plot thermal and soil moisture curves in the dashboard

  # Escenario 1: Consulta de series históricas
  Scenario Outline: Successful telemetry time-series query
    Given a GET request to "/api/v1/plots/<plotId>/telemetries" with parameters "?startDate=<startDate>&endDate=<endDate>"
    When the API validates the time range and retrieves continuous hourly series
    Then the response status is 200
    And the response returns "TelemetrySeriesResource" with temperature, relative humidity and volumetric soil moisture arrays

    Examples:
      | plotId            | startDate            | endDate              |
      | plot-jeronomo-001 | 2026-09-01T00:00:00Z | 2026-09-07T23:59:59Z |

  # Escenario 2: Rango temporal ilógico
  Scenario Outline: Illogical telemetry time range
    Given a GET request with a start date posterior to the end date: "<startDate>", "<endDate>"
    When the API validates date range consistency
    Then the response status is 400

    Examples:
      | plotId            | startDate            | endDate              | reason                  |
      | plot-jeronomo-001 | 2026-09-10T00:00:00Z | 2026-09-01T00:00:00Z | startDate after endDate |
