Feature: Official campaign harvest settlement listing by plot (Harvest)
  As a Client Application Developer
  I want to query historical formal harvest closures via GET to /api/v1/plots/{plotId}/harvest-settlements
  so I can display the multi-year series of official scale weights and delivery balance

  # Escenario 1: Listado paginado exitoso de liquidaciones de cosecha
  Scenario Outline: Paginated listing of official harvest settlements
    Given a GET request to "/api/v1/plots/<plotId>/harvest-settlements" with optional pagination parameters page and size
    When the API validates plot ownership and retrieves formal closures ordered descending by agricultural year
    Then the response status is 200
    And the response returns a paginated list of "HarvestSettlementResource" with green/black kilograms and audit status

    Examples:
      | plotId            | page | size | expectedSettlementCount |
      | plot-jeronomo-001 | 0    | 10   | 2                       |

  # Escenario 2: Cuartel no encontrado en inventario
  Scenario Outline: Plot not found for harvest settlement listing
    Given a GET request with a plotId that does not exist: "<plotId>"
    When the API searches the plot repository
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |
