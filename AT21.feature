Feature: Annual campaign harvest settlement for productive auditing (Phenology)
  As a Client Application Developer
  I want to send harvested kilograms at the close of the season to the API
  so I can record annual plot yield and feed the BBI alternation index calculation

  # Escenario 1: Asentamiento exitoso de cosecha
  Scenario Outline: Successful harvest settlement
    Given a POST request to "/api/v1/plots/<plotId>/harvest-records" with body containing <campaignYear>, <totalYieldKg>, <greenKg> and <blackKg>
    When the API validates plot ownership, verifies quality sum matches total, and persists the record
    Then the response status is 201
    And the response returns "HarvestRecordResource" with audited record details

    Examples:
      | plotId            | campaignYear | totalYieldKg | greenKg | blackKg |
      | plot-jeronomo-001 | 2025         | 12500        | 4500    | 8000    |

  # Escenario 2: Campaña ya registrada previamente
  Scenario Outline: Campaign year already recorded previously
    Given a POST request to "/api/v1/plots/<plotId>/harvest-records" for an already settled campaign year <campaignYear>
    When the API checks the existence of the agricultural year
    Then the response status is 409

    Examples:
      | plotId            | campaignYear |
      | plot-jeronomo-001 | 2024         |

  # Escenario 3: Valores de cosecha inconsistentes
  Scenario Outline: Inconsistent harvest values or future campaign year
    Given a POST request to "/api/v1/plots/<plotId>/harvest-records" with negative yield or future year: <campaignYear>, <totalYieldKg>
    When the API validates numerical fields
    Then the response status is 400

    Examples:
      | plotId            | campaignYear | totalYieldKg | greenKg | blackKg | reason          |
      | plot-jeronomo-001 | 2025         | -500         | -200    | -300    | negative yield  |
      | plot-jeronomo-001 | 2035         | 12000        | 4000    | 8000    | future year     |
