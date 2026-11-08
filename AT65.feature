Feature: Aggregated varietal distribution and commercial aptitude of projected harvest by sector query (Cooperative)
  As a Client Application Developer
  I want to query the intake projection breakdown by olive variety and commercial aptitude via GET to /api/v1/cooperatives/{cooperativeId}/intake-forecasts/varieties with campaignYear parameter and optional sectorId filter
  so I can plan oil mill reception distinguishing table olives (Criolla, Manzanilla) from oil olives

  # Escenario 1: Desglose varietal y comercial de volumen proyectado
  Scenario Outline: Varietal and commercial breakdown of projected volume
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/intake-forecasts/varieties?campaignYear=<campaignYear>&sectorId=<sectorId>" with a technical manager token
    When the API consolidates estimable plot production grouped by agronomic variety (e.g., Criolla de Tacna, Sevillana, Manzanilla) and expected commercial destination
    Then the response status is 200
    And the response returns "VarietyForecastListResource" with an array of varieties containing varietyName, aptitude (TABLE_OLIVE, OIL_OLIVE), estimatedTons, percentageOfTotal and the untyped volume labeled "UNCLASSIFIED"

    Examples:
      | cooperativeId      | campaignYear | sectorId       |
      | coop-valle-sama-01 | 2026         |                |
      | coop-valle-sama-01 | 2026         | sector-sama-01 |

  # Escenario 2: Sector sin parcelas con datos estimables suficientes
  Scenario Outline: Sector without plots with sufficient estimable data
    Given a sector "<sectorId>" where member plots have no validated flowering or fruit set data yet
    When the API computes the sector varietal distribution for campaignYear <campaignYear>
    Then the response status is 200
    And the response returns an empty varietal array and status "NO_DATA" indicating there is no numerical basis to generate the breakdown

    Examples:
      | cooperativeId      | campaignYear | sectorId       |
      | coop-valle-sama-01 | 2026         | sector-sama-07 |

  # Escenario 3: Acceso denegado a usuarios externos a la organización
  Scenario Outline: Access denied to users outside the organization
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/intake-forecasts/varieties" issued by a user with role "<requesterRole>" not belonging to the cooperative technical team
    When the institutional authorization is evaluated
    Then the response status is 403

    Examples:
      | cooperativeId      | requesterRole                     |
      | coop-valle-sama-01 | ROLE_PRODUCTOR                    |
      | coop-valle-sama-01 | ROLE_TECHNICAL_MANAGER_OTHER_COOP |
