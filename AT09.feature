Feature: Cooperative activation code inventory query and audit (Membership)
  As a Client Application Developer
  I want to list the activation codes of the license with an optional status filter via GET to /api/v1/invitation-codes
  so I can audit the invitations and copy or share the available codes

  # Escenario 1: Consulta de códigos de activación
  Scenario Outline: Activation code query
    Given a GET request to "/api/v1/invitation-codes?status=<status>" sent by "<actor>" with an optional status filter
    When the API reads the codes of the manager license
    Then the response status is 200
    And the response returns the codes with their status, expiry and balance

    Examples:
      | status    | actor            |
      | available | usr-manager-0007 |

  # Escenario 2: Recuperación de código utilizable protegido
  Scenario Outline: Protected recovery of a usable code
    Given a GET request to "/api/v1/invitation-codes?status=<status>" sent by "<actor>" for a code AVAILABLE within its validity period
    When the API builds the code representation
    Then the usable code is returned without exposing system secrets

    Examples:
      | status    | actor            |
      | available | usr-manager-0007 |

  # Escenario 3: Acceso denegado a usuarios externos o sin privilegios de gestión
  Scenario Outline: Access denied to users without management privileges
    Given a GET request to "/api/v1/invitation-codes?status=<status>" sent by "<actor>" from a user without the technical manager role
    When the API checks the role
    Then the response status is 403

    Examples:
      | status    | actor           |
      | available | usr-farmer-0042 |
