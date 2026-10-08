Feature: Multi-year plot harvest history query (Phenology)
  As a Client Application Developer
  I want to request the harvest history of a plot from the API
  so I can render the interannual productive yield curve in the interface

  # Escenario 1: Listado cronológico de cosechas
  Scenario Outline: Chronological harvest history listing
    Given a GET request to "/api/v1/plots/<plotId>/harvest-records" with an authorized user token
    When the API retrieves historical productive records of the plot
    Then the response status is 200
    And the response returns an array of "HarvestRecordResource" objects ordered chronologically by campaign year

    Examples:
      | plotId            | expectedCampaignCount |
      | plot-jeronomo-001 | 4                     |

  # Escenario 2: Parcela no encontrada
  Scenario Outline: Plot not found for harvest history query
    Given a GET request to "/api/v1/plots/<plotId>/harvest-records" with a non-existent identifier
    When the API queries the database
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |
