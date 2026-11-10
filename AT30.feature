Feature: Early aggregated projection of sustained green and black olive intake volume (Cooperative)
  As a Client Application Developer
  I want to request the intake projection of a campaign via GET to /api/v1/intake-forecasts/{campaignYear}
  so I can consolidate only the tons backed by estimable plots by commercial aptitude

  # Escenario 1: Proyección agregada basada exclusivamente en parcelas evaluadas
  Scenario Outline: Aggregated projection based only on evaluated plots
    Given a GET request to "/api/v1/intake-forecasts/<campaignYear>" sent by "<actor>" for the campaign in progress
    When the API adds up the evaluated member plots
    Then the response status is 200
    And the response returns total, green, black and unclassified tons with coverage

    Examples:
      | campaignYear | actor            |
      | 2026         | usr-manager-0007 |

  # Escenario 2: Notificación de cobertura muestral parcial
  Scenario Outline: Partial sampling coverage notice
    Given a GET request to "/api/v1/intake-forecasts/<campaignYear>" sent by "<actor>" for a cooperative with low evaluation coverage
    When the API computes the coverage
    Then the response status is 200
    And the response marks the projection as PRELIMINARY

    Examples:
      | campaignYear | actor            |
      | 2026         | usr-manager-0007 |

  # Escenario 3: Acceso no autorizado para usuarios sin rol institucional
  Scenario Outline: Unauthorized access for users without institutional role
    Given a GET request to "/api/v1/intake-forecasts/<campaignYear>" sent by "<actor>" from a user without the technical manager role
    When the API checks the role
    Then the response status is 403

    Examples:
      | campaignYear | actor           |
      | 2026         | usr-farmer-0042 |
