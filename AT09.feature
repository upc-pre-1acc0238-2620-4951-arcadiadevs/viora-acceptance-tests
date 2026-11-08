Feature: Cooperative activation code batch inventory query and audit (Membership)
  As a Client Application Developer
  I want to request the paginated inventory of activation code batches via GET to /api/v1/cooperatives/{cooperativeId}/invitation-code-batches with status filters and protected recoverable storage
  so I can let the manager audit invitations and copy or share available codes

  # Escenario 1: Consulta paginada y agrupada de códigos de activación
  Scenario Outline: Paginated and grouped activation code query
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/invitation-code-batches" with optional parameters "?status=<status>&page=<page>&size=<size>" authorized with a ROLE_TECHNICAL_MANAGER token
    When the API queries the codes repository and computes the cooperative global totals
    Then the response status is 200
    And the response returns "PagedInvitationCodeBatchResource" with paginated batches, readable codes for AVAILABLE status, expiresAt, issue date and institutional balance summary

    Examples:
      | cooperativeId      | status    | page | size |
      | coop-valle-sama-01 | AVAILABLE | 0    | 20   |
      | coop-valle-sama-01 | REDEEMED  | 0    | 20   |
      | coop-valle-sama-01 | EXPIRED   | 1    | 10   |
      | coop-valle-sama-01 | REVOKED   | 0    | 10   |

  # Escenario 2: Recuperación de código utilizable protegido
  Scenario Outline: Protected usable code retrieval
    Given a generated code "<codeId>" in AVAILABLE status within its validity period
    When the authorized technical manager requests its detail to share it from the mobile application
    Then the response status is 200
    And the response returns the usable representation of the code allowing clipboard copy without exposing system secrets

    Examples:
      | cooperativeId      | codeId       |
      | coop-valle-sama-01 | code-0001-av |

  # Escenario 3: Acceso denegado a usuarios externos o sin privilegios de gestión
  Scenario Outline: Access denied to external users or users without management privileges
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/invitation-code-batches" sent by an account not associated with the cooperative in the route
    When the service checks the authorization scope
    Then the response status is 403
    And the institutional codes remain confidential

    Examples:
      | cooperativeId      | requesterRole                     |
      | coop-valle-sama-01 | ROLE_PRODUCTOR                    |
      | coop-valle-sama-01 | ROLE_TECHNICAL_MANAGER_OTHER_COOP |
