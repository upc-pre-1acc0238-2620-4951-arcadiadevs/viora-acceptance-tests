Feature: Member plot sector assignment query (Cooperative)
  As a Client Application Developer
  I want to list the sectors of the plots with an optional status filter via GET to /api/v1/plot-sector-assignments
  so I can group the plots by sector and find the ones pending confirmation

  # Escenario 1: Consulta de sectores por parcela
  Scenario Outline: Sector by plot query
    Given a GET request to "/api/v1/plot-sector-assignments?status=<status>" sent by "<actor>" from a technical manager or a member
    When the API applies the scope of the user
    Then the response status is 200
    And the manager gets every member plot and the member only their own plots

    Examples:
      | status    | actor            |
      | available | usr-manager-0007 |

  # Escenario 2: Estado desconocido
  Scenario Outline: Unknown status
    Given a GET request to "/api/v1/plot-sector-assignments?status=<status>" sent by "<actor>" with an unknown status filter
    When the API validates the parameter
    Then the response status is 400

    Examples:
      | status    | actor            |
      | available | usr-manager-0007 |

  # Escenario 3: Usuario sin licencia asociada
  Scenario Outline: User without an associated license
    Given a GET request to "/api/v1/plot-sector-assignments?status=<status>" sent by "<actor>" from a user who reaches no license
    When the API checks the access
    Then the response status is 403

    Examples:
      | status    | actor            |
      | available | usr-manager-0007 |

  # Escenario 4: Solicitud sin autenticación
  Scenario Outline: Request without authentication
    Given a GET request to "/api/v1/plot-sector-assignments?status=<status>" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | status    | actor            |
      | available | anonymous-client |
