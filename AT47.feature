Feature: Agroclimatic incidents query associated with specific plot (Telemetry)
  As a Client Application Developer
  I want to query plot agroclimatic incidents via GET to /api/v1/plots/{plotId}/agroclimatic-incidents
  so I can display climatic risks and recommendations in the individual plot card

  # Escenario 1: Listado exitoso de incidentes del cuartel
  Scenario Outline: Successful listing of plot incidents
    Given a GET request to "/api/v1/plots/<plotId>/agroclimatic-incidents" with optional filters
    When the API validates plot ownership and retrieves anomaly events associated with the plot
    Then the response status is 200
    And the response returns a collection of "AgroclimaticIncidentResponse" with risk typology, measured values, thresholds and mitigation status

    Examples:
      | plotId            | activeOnly | expectedIncidentCount |
      | plot-jeronomo-001 | true       | 1                     |

  # Escenario 2: Cuartel no encontrado en inventario
  Scenario Outline: Plot not found for incidents query
    Given a GET request to "/api/v1/plots/<plotId>/agroclimatic-incidents" with a non-existent plotId
    When the service queries plot existence
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |
