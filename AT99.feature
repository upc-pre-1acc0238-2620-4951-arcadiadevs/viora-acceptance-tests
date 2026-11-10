Feature: Sector assignment to a plot (Cooperative)
  As a Client Application Developer
  I want to give a plot a sector with sectorZoneId or name via PUT to /api/v1/plot-sector-assignments/{plotId}
  so I can group the plot within the territorial organization

  # Escenario 1: Sector asignado
  Scenario Outline: Sector assigned
    Given a PUT request to "/api/v1/plot-sector-assignments/<plotId>" sent by "<actor>" with a sector of the list or a name that matches it
    When the API assigns the sector
    Then the response status is 200

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 2: Nombre pendiente de confirmación
  Scenario Outline: Name pending confirmation
    Given a PUT request to "/api/v1/plot-sector-assignments/<plotId>" sent by "<actor>" with a name that matches no sector of the list
    When the API processes the assignment
    Then the response status is 200
    And the plot stays pending until the manager reviews it

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 3: Datos inválidos
  Scenario Outline: Invalid data
    Given a PUT request to "/api/v1/plot-sector-assignments/<plotId>" sent by "<actor>" without both fields, with both or with an invalid name
    When the API validates the request
    Then the response status is 400

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 4: Productor sin plan patrocinado
  Scenario Outline: Producer without a sponsored plan
    Given a PUT request to "/api/v1/plot-sector-assignments/<plotId>" sent by "<actor>" from a producer without a sponsored plan
    When the API checks the access
    Then the response status is 403

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 5: Parcela o sector no encontrado
  Scenario Outline: Plot or sector not found
    Given a PUT request to "/api/v1/plot-sector-assignments/<plotId>" sent by "<actor>" for a plot that is not an active member plot or a sector outside the license
    When the API searches them
    Then the response status is 404

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 6: Solicitud sin autenticación
  Scenario Outline: Request without authentication
    Given a PUT request to "/api/v1/plot-sector-assignments/<plotId>" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | plotId          | actor            |
      | plot-yarada-001 | anonymous-client |
