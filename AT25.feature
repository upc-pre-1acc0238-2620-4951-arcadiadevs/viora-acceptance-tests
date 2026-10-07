Feature: Statistical representativeness and sampling status query (Thinning)
  As a Client Application Developer
  I want to request sampling representativeness status from the API
  so I can notify the user whether enough trees have been evaluated to issue reliable prescriptions

  # Escenario 1: Consulta de cobertura de muestreos
  Scenario Outline: Sampling coverage and sufficiency query
    Given a GET request to "/api/v1/plots/<plotId>/samplings" with authorized token
    When the API consolidates trees evaluated in the active campaign
    Then the response status is 200
    And the response returns "SamplingSummaryResource" with total trees evaluated, percentage representativeness and isSampleSufficient flag

    Examples:
      | plotId            | expectedSampledTrees | isSampleSufficient |
      | plot-jeronomo-001 | 6                    | true               |
      | plot-scarce-002   | 3                    | false              |

  # Escenario 2: Parcela no encontrada
  Scenario Outline: Plot not found for sampling status query
    Given a GET request with an invalid or non-existent plotId: "<plotId>"
    When the API searches persistence
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |
