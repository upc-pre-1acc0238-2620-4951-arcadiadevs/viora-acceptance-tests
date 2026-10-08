Feature: Formal harvest settlement and season-end delivery balance (Harvest)
  As a Client Application Developer
  I want to submit formal harvest settlement via POST to /api/v1/plots/{plotId}/harvest-settlements
  so I can record the official scale delivery, compute prescription balance and freeze the interannual stabilization curve

  # Escenario 1: Asentamiento exitoso de liquidación de cosecha con balance y estabilización
  Scenario Outline: Successful harvest settlement with balance and stabilization
    Given a POST request to "/api/v1/plots/<plotId>/harvest-settlements" with body containing <campaignYear>, <greenOlivesKg>, <blackOlivesKg>, <commercialFruitsPerKg> and "<notes>"
    When the API validates ownership, verifies positive kilograms, computes thinning balance and calculates alternation stabilization
    Then the response status is 201
    And the response returns "HarvestSettlementResource" with audited breakdown and publishes CampaignHarvestSettledEvent

    Examples:
      | plotId            | campaignYear | greenOlivesKg | blackOlivesKg | commercialFruitsPerKg | notes                    |
      | plot-jeronomo-001 | 2025         | 4200.0        | 8100.0        | 220                   | Final mill delivery cert |

  # Escenario 2: Parámetros inválidos o inconsistencia en pesajes
  Scenario Outline: Invalid parameters or weight inconsistency in settlement
    Given a POST request with negative weight or invalid campaign year: <campaignYear>, <greenOlivesKg>, <blackOlivesKg>
    When the domain validator processes the payload
    Then the response status is 400

    Examples:
      | plotId            | campaignYear | greenOlivesKg | blackOlivesKg | reason               |
      | plot-jeronomo-001 | 2025         | -100.0        | 500.0         | negative green olive |
      | plot-jeronomo-001 | 1990         | 1000.0        | 1000.0        | year out of range    |

  # Escenario 3: Parcela no encontrada o inactiva
  Scenario Outline: Plot not found or inactive for settlement
    Given a POST request with a non-existent plotId: "<plotId>"
    When the API searches the repository
    Then the response status is 404

    Examples:
      | plotId                | campaignYear |
      | plot-non-existent-999 | 2025         |

  # Escenario 4: Conflicto por campaña ya liquidada previamente
  Scenario Outline: Conflict when settlement already exists for campaign year
    Given a POST request for a campaign year already settled and immutable: <campaignYear>
    When the application service validates the annual closure uniqueness rule
    Then the response status is 409

    Examples:
      | plotId            | campaignYear |
      | plot-jeronomo-001 | 2024         |
