Feature: Institutional license balance and corporate quota query (Membership)
  As a Client Application Developer
  I want to query a license of the technical manager via GET to /api/v1/cooperative-licenses/{id}
  so I can show the balance of seats and hectares of the cooperative

  # Escenario 1: Consulta exitosa de la licencia
  Scenario Outline: Successful license query
    Given a GET request to "/api/v1/cooperative-licenses/<id>" sent by "<actor>" for a license in charge of the manager
    When the API reads the license
    Then the response status is 200
    And the response returns the license and its balance

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Escenario 2: Licencia inexistente o ajena
  Scenario Outline: Unknown or foreign license
    Given a GET request to "/api/v1/cooperative-licenses/<id>" sent by "<actor>" for a license not in charge of the manager
    When the API searches the license
    Then the response status is 404

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Escenario 3: Solicitud sin autenticación
  Scenario Outline: Request without authentication
    Given a GET request to "/api/v1/cooperative-licenses/<id>" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | anonymous-client |

  # Escenario 4: Usuario sin rol de gestor técnico
  Scenario Outline: User without the technical manager role
    Given a GET request to "/api/v1/cooperative-licenses/<id>" sent by "<actor>" from a user who is not a technical manager
    When the API checks the role
    Then the response status is 403

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
