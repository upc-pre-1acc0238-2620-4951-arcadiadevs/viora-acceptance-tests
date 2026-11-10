Feature: Territorial sector query (Cooperative)
  As a Client Application Developer
  I want to query a sector via GET to /api/v1/sector-zones/{id}
  so I can retrieve its information

  # Escenario 1: Consulta exitosa
  Scenario Outline: Successful query
    Given a GET request to "/api/v1/sector-zones/<id>" sent by "<actor>" for a sector of the license
    When the API reads the sector
    Then the response status is 200

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Escenario 2: Sector no encontrado
  Scenario Outline: Sector not found
    Given a GET request to "/api/v1/sector-zones/<id>" sent by "<actor>" for a sector outside the license
    When the API searches the sector
    Then the response status is 404

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Escenario 3: Solicitud sin autenticación
  Scenario Outline: Request without authentication
    Given a GET request to "/api/v1/sector-zones/<id>" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | anonymous-client |

  # Escenario 4: Usuario sin licencia asociada
  Scenario Outline: User without an associated license
    Given a GET request to "/api/v1/sector-zones/<id>" sent by "<actor>" from a user who reaches no license
    When the API checks the access
    Then the response status is 403

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |
