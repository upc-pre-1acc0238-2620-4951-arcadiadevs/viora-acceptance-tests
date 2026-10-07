Feature: Detailed harvest settlement query by individual campaign year (Harvest)
  As a Client Application Developer
  I want to query the formal voucher of a specific settlement via GET to /api/v1/plots/{plotId}/harvest-settlements/{campaignYear}
  so I can display certified weight, thinning balance and the Alternation Reduction Rate (ARR)

  # Escenario 1: Consulta exitosa de liquidación de campaña con balance y métricas
  Scenario Outline: Successful individual campaign settlement query
    Given a GET request to "/api/v1/plots/<plotId>/harvest-settlements/<campaignYear>" with route parameters plotId and campaignYear
    When the API validates existence of formal settlement for said year and plot
    Then the response status is 200
    And the response returns "HarvestSettlementResource" with totalYieldKg, commercialFruitsPerKg, thinningBalance and stabilization ARR

    Examples:
      | plotId            | campaignYear | expectedYield | expectedARR |
      | plot-jeronomo-001 | 2025         | 12300.0       | 0.35        |

  # Escenario 2: Liquidación de campaña o cuartel no encontrado
  Scenario Outline: Settlement or plot not found for campaign year
    Given a GET request with non-existent plotId or unliquidated campaignYear: "<plotId>", <campaignYear>
    When the service queries the settlements repository
    Then the response status is 404

    Examples:
      | plotId                | campaignYear |
      | plot-non-existent-999 | 2025         |
      | plot-jeronomo-001     | 2030         |
