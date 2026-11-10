Feature: License territorial sectors query (Cooperative)
  As a Client Application Developer
  I want to list the sectors of the license via GET to /api/v1/sector-zones
  so I can organize the cooperative plots by sector

  # Escenario 1: Listado de sectores
  Scenario Outline: Sectors list
    Given a GET request to "/api/v1/sector-zones" sent by "<actor>" from a manager with a license or a member with a sponsored plan
    When the API reads the sectors of their license
    Then the response status is 200
    And each sector counts its member plots

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Escenario 2: Solicitud sin autenticación
  Scenario Outline: Request without authentication
    Given a GET request to "/api/v1/sector-zones" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | actor            |
      | anonymous-client |

  # Escenario 3: Usuario sin licencia asociada
  Scenario Outline: User without an associated license
    Given a GET request to "/api/v1/sector-zones" sent by "<actor>" from a manager without a license in force or a producer without a sponsored plan
    When the API checks the access
    Then the response status is 403

    Examples:
      | actor            |
      | usr-manager-0007 |
