Feature: Detailed query of agronomic and spatial plot information (Orchard)
  As a Client Application Developer
  I want to request the details of a plot by its ID
  so I can display the complete agronomic profile of the plot in the user interface

  # Escenario 1: Obtención de detalle de parcela
  Scenario Outline: Retrieve plot details successfully
    Given a GET request to "/api/v1/plots/<plotId>" with an authorized token
    When the API verifies ownership and retrieves the plot
    Then the response status is 200
    And the response returns "PlotDetailResource" with geometry, variety, density, planting year and linked sensors

    Examples:
      | plotId            | plotName          | variety |
      | plot-jeronomo-001 | San Jeronimo Plot | CRIOLLA |

  # Escenario 2: Parcela inexistente
  Scenario Outline: Non-existent plot query
    Given a GET request to "/api/v1/plots/<plotId>" with a non-existent identifier
    When the API searches the database
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |
