Feature: Territorial sector rename (Cooperative)
  As a Client Application Developer
  I want to rename a sector via PATCH to /api/v1/sector-zones/{id}
  so I can show the new name on every plot of the sector

  # Escenario 1: Sector renombrado
  Scenario Outline: Sector renamed
    Given a PATCH request to "/api/v1/sector-zones/<id>" sent by "<actor>" from a technical manager with a license in force
    When the API updates the name
    Then the response status is 200

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Escenario 2: Nombre inválido
  Scenario Outline: Invalid name
    Given a PATCH request to "/api/v1/sector-zones/<id>" sent by "<actor>" with a blank, too short or too long name
    When the API validates the name
    Then the response status is 400

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Escenario 3: Sector no encontrado
  Scenario Outline: Sector not found
    Given a PATCH request to "/api/v1/sector-zones/<id>" sent by "<actor>" for a sector outside the license
    When the API searches the sector
    Then the response status is 404

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Escenario 4: Nombre repetido
  Scenario Outline: Repeated name
    Given a PATCH request to "/api/v1/sector-zones/<id>" sent by "<actor>" with a name used by another sector
    When the API validates its uniqueness
    Then the response status is 409

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Escenario 5: Solicitud sin autenticación
  Scenario Outline: Request without authentication
    Given a PATCH request to "/api/v1/sector-zones/<id>" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | anonymous-client |

  # Escenario 6: Gestor sin licencia vigente
  Scenario Outline: Manager without a license in force
    Given a PATCH request to "/api/v1/sector-zones/<id>" sent by "<actor>" from a user who is not a manager with a license in force
    When the API checks the access
    Then the response status is 403

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
