Feature: Chronological events and agronomic thinning log query (Thinning)
  As a Client Application Developer
  I want to query historical thinning events via GET to /api/v1/plots/{plotId}/thinning-events
  so I can display the chronological sequence of sampling, prescription and confirmation in the plot

  # Escenario 1: Consulta cronológica exitosa de bitácora de intervenciones
  Scenario Outline: Successful chronological query of thinning events log
    Given a GET request to "/api/v1/plots/<plotId>/thinning-events" with optional campaignYear <campaignYear>
    When the API retrieves the chronological sequence of sampling, prescription and execution confirmation events
    Then the response status is 200
    And the response returns a collection of "ThinningEventResponse" with event type, occurrence date, actors and notes

    Examples:
      | plotId            | campaignYear | expectedEventCount |
      | plot-jeronomo-001 | 2025         | 4                  |

  # Escenario 2: Cuartel no encontrado
  Scenario Outline: Plot not found for thinning events query
    Given a GET request with a non-existent plotId: "<plotId>"
    When the API evaluates plot existence
    Then the response status is 404

    Examples:
      | plotId                | campaignYear |
      | plot-non-existent-999 | 2025         |
