Feature: Pending sector review (Cooperative)
  As a Client Application Developer
  I want to resolve a sector pending confirmation via POST to /api/v1/plot-sector-assignments/{plotId}/resolutions
  so I can consolidate the sector list of the license

  # Escenario 1: Revisión exitosa
  Scenario Outline: Successful review
    Given a POST request to "/api/v1/plot-sector-assignments/<plotId>/resolutions" sent by "<actor>" for a plot pending confirmation
    When the API adds the name to the list or links the plot to an existing sector for every plot with the same name
    Then the response status is 200

    Examples:
      | plotId          | actor            |
      | plot-yarada-001 | usr-manager-0007 |

  # Escenario 2: Parcela o sector no encontrado
  Scenario Outline: Plot or sector not found
    Given a POST request to "/api/v1/plot-sector-assignments/<plotId>/resolutions" sent by "<actor>" for a plot or sector outside the license
    When the API searches them
    Then the response status is 404

    Examples:
      | plotId          | actor            |
      | plot-yarada-001 | usr-manager-0007 |

  # Escenario 3: Parcela ya revisada
  Scenario Outline: Plot already reviewed
    Given a POST request to "/api/v1/plot-sector-assignments/<plotId>/resolutions" sent by "<actor>" for a plot that is no longer pending
    When the API checks its status
    Then the response status is 409

    Examples:
      | plotId          | actor            |
      | plot-yarada-001 | usr-manager-0007 |

  # Escenario 4: Solicitud sin autenticación
  Scenario Outline: Request without authentication
    Given a POST request to "/api/v1/plot-sector-assignments/<plotId>/resolutions" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | plotId          | actor            |
      | plot-yarada-001 | anonymous-client |

  # Escenario 5: Gestor sin licencia vigente
  Scenario Outline: Manager without a license in force
    Given a POST request to "/api/v1/plot-sector-assignments/<plotId>/resolutions" sent by "<actor>" from a user who is not a manager with a license in force
    When the API checks the access
    Then the response status is 403

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |
