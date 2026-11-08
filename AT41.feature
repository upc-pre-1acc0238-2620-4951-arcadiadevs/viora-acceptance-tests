Feature: Early cooperative activation code revocation and quota restitution (Membership)
  As a Client Application Developer
  I want to submit an immediate revocation request for an available activation code via POST to /api/v1/cooperatives/{cooperativeId}/invitation-codes/{codeId}/expiry-adjustments
  so I can cancel the invitation and atomically restore the reserved seat and hectares to the institutional license balance

  # Escenario 1: Revocación exitosa y restitución de cupo a la licencia
  Scenario Outline: Successful revocation and quota restitution to the license
    Given a POST request to "/api/v1/cooperatives/<cooperativeId>/invitation-codes/<codeId>/expiry-adjustments" authorized with a ROLE_TECHNICAL_MANAGER token
    When the API verifies the code belongs to the cooperative and is in AVAILABLE status
    Then the response status is 200
    And the code status is updated to REVOKED and "InvitationCodeRevokedEvent" is emitted
    And the corresponding seat and <quotaHa> hectares are restored to the available balance in "CooperativeLicense"

    Examples:
      | cooperativeId      | codeId       | quotaHa |
      | coop-valle-sama-01 | code-0001-av | 5.0     |

  # Escenario 2: Código ya canjeado o inactivo
  Scenario Outline: Code already redeemed or inactive
    Given a POST request to "/api/v1/cooperatives/<cooperativeId>/invitation-codes/<codeId>/expiry-adjustments" for a code in status "<codeStatus>"
    When the API processes the code lifecycle rule
    Then the response status is 409
    And the response indicates consumed or inactive codes cannot be revoked

    Examples:
      | cooperativeId      | codeId       | codeStatus |
      | coop-valle-sama-01 | code-0002-rd | REDEEMED   |
      | coop-valle-sama-01 | code-0003-rv | REVOKED    |
      | coop-valle-sama-01 | code-0004-ex | EXPIRED    |

  # Escenario 3: Denegación de acceso para usuarios no gestores
  Scenario Outline: Access denied for non-manager users
    Given a POST request to "/api/v1/cooperatives/<cooperativeId>/invitation-codes/<codeId>/expiry-adjustments" sent by a user with role "<requesterRole>" without technical manager role in the cooperative
    When the service evaluates authorization
    Then the response status is 403

    Examples:
      | cooperativeId      | codeId       | requesterRole  |
      | coop-valle-sama-01 | code-0001-av | ROLE_PRODUCTOR |
