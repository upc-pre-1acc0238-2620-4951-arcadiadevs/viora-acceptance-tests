Feature: Technical manager institutional context and membership query (Membership)
  As a Client Application Developer
  I want to query the institutional context of the authenticated technical manager via GET to /api/v1/manager-context
  so I can determine the cooperatives they are assigned to, their enablement status (PENDING/ACTIVE) and the institutional identifiers needed to navigate the application

  # Escenario 1: Consulta exitosa de contexto con cooperativa asignada activa
  Scenario Outline: Successful context query with active assigned cooperative
    Given a GET request to "/api/v1/manager-context" with a JWT token containing the role claim "<role>"
    When the membership service queries the user institutional assignments
    Then the response status is 200
    And the response returns "ManagerContextResource" with managerId, fullName, status "ACTIVE" and a list of linked cooperatives with cooperativeId, cooperativeName, licenseId and memberCount

    Examples:
      | role                   | managerId    | cooperativeId      | memberCount |
      | ROLE_TECHNICAL_MANAGER | usr-mgr-0007 | coop-valle-sama-01 | 48          |

  # Escenario 2: Gestor técnico con asignación institucional pendiente de confirmación
  Scenario Outline: Technical manager with institutional assignment pending confirmation
    Given an authenticated user "<managerId>" with technical manager role whose affiliation to the guild entity has not been approved yet
    When the API retrieves their institutional status
    Then the response status is 200
    And the response returns status "PENDING" and an empty cooperatives array so the application shows the institutional confirmation waiting screen

    Examples:
      | managerId    |
      | usr-mgr-0099 |

  # Escenario 3: Acceso no facultado para usuarios sin rol de gestor
  Scenario Outline: Unauthorized access for users without manager role
    Given a GET request to "/api/v1/manager-context" issued by a user with role "<requesterRole>"
    When the security guard evaluates the token
    Then the response status is 403

    Examples:
      | requesterRole  |
      | ROLE_PRODUCTOR |
