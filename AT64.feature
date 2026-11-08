Feature: Corporate invitation code delivery and sharing registration and traceability (Membership)
  As a Client Application Developer
  I want to register the action of sharing or preliminarily assigning an activation code via POST to /api/v1/cooperatives/{cooperativeId}/invitation-codes/{codeId}/shares with optional recipient metadata
  so I can keep the invitation delivery log in the management interface

  # Escenario 1: Registro exitoso de compartición de código de activación
  Scenario Outline: Successful activation code sharing registration
    Given a POST request to "/api/v1/cooperatives/<cooperativeId>/invitation-codes/<codeId>/shares" with body containing sharedVia "<sharedVia>" and optional label intendedRecipientName "<intendedRecipientName>" authorized with a manager token
    When the API validates the code is in AVAILABLE status and belongs to the cooperative
    Then the response status is 200
    And the response returns "CodeShareResource" with delivery timestamp and annotation status in the internal log

    Examples:
      | cooperativeId      | codeId       | sharedVia | intendedRecipientName |
      | coop-valle-sama-01 | code-0001-av | WHATSAPP  | Rosa Mamani           |
      | coop-valle-sama-01 | code-0001-av | SMS       |                       |
      | coop-valle-sama-01 | code-0001-av | CLIPBOARD |                       |

  # Escenario 2: Intento de registro sobre código ya canjeado o inactivo
  Scenario Outline: Registration attempt on an already redeemed or inactive code
    Given a POST request to "/api/v1/cooperatives/<cooperativeId>/invitation-codes/<codeId>/shares" for a code in status "<codeStatus>"
    When the API checks the code lifecycle status
    Then the response status is 409
    And the response follows RFC 7807 preventing delivery registration of unusable codes

    Examples:
      | cooperativeId      | codeId       | codeStatus |
      | coop-valle-sama-01 | code-0002-rd | REDEEMED   |
      | coop-valle-sama-01 | code-0004-ex | EXPIRED    |
      | coop-valle-sama-01 | code-0003-rv | REVOKED    |

  # Escenario 3: Acceso no autorizado
  Scenario Outline: Unauthorized access
    Given a POST request to "/api/v1/cooperatives/<cooperativeId>/invitation-codes/<codeId>/shares" sent by a user with role "<requesterRole>" without technical manager role in the cooperative
    When the service evaluates the credentials
    Then the response status is 403

    Examples:
      | cooperativeId      | codeId       | requesterRole  |
      | coop-valle-sama-01 | code-0001-av | ROLE_PRODUCTOR |
