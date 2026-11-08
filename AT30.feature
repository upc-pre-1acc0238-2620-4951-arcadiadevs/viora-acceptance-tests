Feature: Early aggregated projection of sustained green and black olive intake volume (Cooperative)
  As a Client Application Developer
  I want to request the early aggregated intake projection via GET to /api/v1/cooperatives/{cooperativeId}/intake-forecasts with campaignYear parameter
  so I can consolidate only the tons backed by estimable plots and show the breakdown by commercial aptitude (green for table and black for oil mill)

  # Escenario 1: Proyección agregada basada exclusivamente en parcelas evaluadas
  Scenario Outline: Aggregated projection based exclusively on evaluated plots
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/intake-forecasts?campaignYear=<campaignYear>" with a technical manager token
    When the API consolidates the expected production adding only member plots with a valid fruit set sampling, without extrapolations or arbitrary reduction coefficients
    Then the response status is 200
    And the response returns "IntakeForecastResource" with totalEstimatedTons, greenOlivesTons, blackOlivesTons, unclassifiedTons, sampledPlots, totalPlots and coveragePercentage

    Examples:
      | cooperativeId      | campaignYear | sampledPlots | totalPlots | coveragePercentage |
      | coop-valle-sama-01 | 2026         | 42           | 50         | 84.0               |

  # Escenario 2: Notificación de cobertura muestral parcial
  Scenario Outline: Partial sampling coverage notification
    Given a cooperative "<cooperativeId>" where evaluated plot coverage is <coveragePercentage>% of the roster, below 60%
    When the API computes the aggregated projection for campaignYear <campaignYear>
    Then the response status is 200
    And the response includes status "PRELIMINARY" and an insufficient representativeness indicator warning that field evaluations must be completed

    Examples:
      | cooperativeId      | campaignYear | sampledPlots | totalPlots | coveragePercentage |
      | coop-valle-sama-01 | 2026         | 20           | 50         | 40.0               |

  # Escenario 3: Acceso no autorizado para usuarios sin rol institucional
  Scenario Outline: Unauthorized access for users without institutional role
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/intake-forecasts" issued by an account with role "<requesterRole>" without ROLE_TECHNICAL_MANAGER in the entity
    When the service validates permissions
    Then the response status is 403

    Examples:
      | cooperativeId      | requesterRole  |
      | coop-valle-sama-01 | ROLE_PRODUCTOR |
