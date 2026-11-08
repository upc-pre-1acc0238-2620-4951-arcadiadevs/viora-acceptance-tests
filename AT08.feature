Feature: Activation code batch generation for cooperative members with quota reservation (Membership)
  As a Client Application Developer
  I want to submit an activation code batch generation request via POST to /api/v1/cooperatives/{cooperativeId}/invitation-code-batches specifying quantity, validity days and hectare quota per code
  so I can issue unnamed invitations and atomically reserve seats and hectares in the institutional license

  # Escenario 1: Generación exitosa de lote con reserva atómica de plazas y hectáreas
  Scenario Outline: Successful batch generation with atomic seat and hectare reservation
    Given a POST request to "/api/v1/cooperatives/<cooperativeId>/invitation-code-batches" with header "Authorization: Bearer <token>" of a technical manager and body containing <quantity>, <validDays> and <quotaHaPerCode>
    When the API verifies the manager holds ROLE_TECHNICAL_MANAGER, belongs to the cooperative and the license has enough seats and hectare balance to cover the batch
    Then the response status is 201
    And the response returns "InvitationCodeBatchResource" with batchId, quantity, validDays, quotaHaPerCode, an array of unnamed codes with format "COOP-XXXX", expiresAt and remaining license balance
    And the corresponding seats and hectares are atomically reserved in "CooperativeLicense"

    Examples:
      | cooperativeId      | token             | quantity | validDays | quotaHaPerCode |
      | coop-valle-sama-01 | jwt-manager-valid | 10       | 30        | 5.0            |
      | coop-valle-sama-01 | jwt-manager-valid | 1        | 7         | 2.5            |

  # Escenario 2: Cupo o hectáreas insuficientes en la licencia colectiva
  Scenario Outline: Insufficient seats or hectares in the collective license
    Given a POST request to "/api/v1/cooperatives/<cooperativeId>/invitation-code-batches" with <quantity> codes and <quotaHaPerCode> hectares per code exceeding the available corporate subscription balance
    When the API validates the contractual limits of the "CooperativeLicense" aggregate
    Then the response status is 400
    And the response indicates there is not enough institutional quota to complete the issuance

    Examples:
      | cooperativeId      | quantity | quotaHaPerCode | reason                |
      | coop-valle-sama-01 | 500      | 5.0            | insufficient seats    |
      | coop-valle-sama-01 | 5        | 900.0          | insufficient hectares |

  # Escenario 3: Acceso no autorizado para usuarios sin rol de gestor técnico
  Scenario Outline: Unauthorized access for users without technical manager role
    Given a POST request to "/api/v1/cooperatives/<cooperativeId>/invitation-code-batches" issued by a user with role "<requesterRole>"
    When the security filter evaluates the credentials and institutional membership
    Then the response status is 403
    And the code generation is blocked

    Examples:
      | cooperativeId      | requesterRole                     |
      | coop-valle-sama-01 | ANONYMOUS                         |
      | coop-valle-sama-01 | ROLE_PRODUCTOR                    |
      | coop-valle-sama-01 | ROLE_TECHNICAL_MANAGER_OTHER_COOP |
