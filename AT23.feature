Feature: Computation and delivery of BBI alternation metrics and Erez dynamic chill (Phenology)
  As a Client Application Developer
  I want to request mathematical alternation and winter chilling metrics from the API
  so I can display the BBI index and accumulated chill portions with ENOS thermal alerts

  # Escenario 1: Cálculo exitoso de índice BBI o frío de Erez
  Scenario Outline: Successful calculation of BBI index or Erez chill portions
    Given a GET request to "/api/v1/plots/<plotId>/metrics" with parameter "?name=<metricName>"
    When the API computes the Hoblyn formula or executes the Erez dynamic model over hourly temperatures
    Then the response status is 200
    And the response returns "MetricResource" with numerical value, severity category and enosAnomalyDetected flag

    Examples:
      | plotId            | metricName | expectedSeverity | enosAnomaly |
      | plot-jeronomo-001 | BBI        | MODERATE         | false       |
      | plot-jeronomo-001 | CHILLING   | SUFFICIENT       | true        |

  # Escenario 2: Datos insuficientes para el cálculo
  Scenario Outline: Insufficient data for metric calculation
    Given a GET request for BBI in a plot with fewer than 3 registered campaigns: "<plotId>"
    When the API validates statistical requirements
    Then the response status is 400
    And the response indicates that at least 3 agricultural campaigns are required

    Examples:
      | plotId           | recordedCampaigns |
      | plot-newborn-002 | 1                 |
