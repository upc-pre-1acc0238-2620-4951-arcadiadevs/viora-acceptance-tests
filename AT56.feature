Feature: Technical manager license query (Membership)
  As a Client Application Developer
  I want to list the licenses of the authenticated technical manager via GET to /api/v1/cooperative-licenses
  so I can know whether the manager is in charge of a license in force

  # Escenario 1: Consulta de la licencia del gestor
  Scenario Outline: Manager license query
    Given a GET request to "/api/v1/cooperative-licenses" sent by "<actor>" from a technical manager
    When the API reads the licenses in charge of the manager
    Then the response status is 200
    And the response returns at most one license and whether it is in force

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Escenario 2: Gestor sin licencia asignada
  Scenario Outline: Manager without an assigned license
    Given a GET request to "/api/v1/cooperative-licenses" sent by "<actor>" from a technical manager without a license
    When the API reads the licenses of the manager
    Then the response status is 200
    And the response returns an empty list

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Escenario 3: Solicitud sin autenticación
  Scenario Outline: Request without authentication
    Given a GET request to "/api/v1/cooperative-licenses" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | actor            |
      | anonymous-client |

  # Escenario 4: Usuario sin rol de gestor técnico
  Scenario Outline: User without the technical manager role
    Given a GET request to "/api/v1/cooperative-licenses" sent by "<actor>" from a user who is not a technical manager
    When the API checks the role
    Then the response status is 403

    Examples:
      | actor           |
      | usr-farmer-0042 |
