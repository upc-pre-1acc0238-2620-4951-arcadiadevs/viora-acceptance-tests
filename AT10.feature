Feature: Atomic institutional activation code redemption with quota and consent validation (Membership)
  As a Client Application Developer
  I want to submit the corporate activation code provided by the farmer and their data sharing consent via POST to /api/v1/cooperative-code-redemptions
  so I can atomically validate the quota, affiliate the account to the cooperative and activate sponsored benefits without individual charge

  # Escenario 1: Canje exitoso, validación de cuota y vinculación 1:N
  Scenario Outline: Successful redemption, quota validation and 1:N linking
    Given a POST request to "/api/v1/cooperative-code-redemptions" with body containing invitationCode "<invitationCode>" and shareDataConsent <shareDataConsent> issued by an authenticated olive farmer
    When the API validates the code exists, is AVAILABLE, has not expired and the cooperative has hectare quota for the member surface
    Then the response status is 200
    And the response returns "CooperativeCodeRedemptionResource" with affiliation confirmation, cooperative name and active sponsored membership status
    And the code transitions to REDEEMED, "CooperativeCodeRedeemedEvent" is emitted and the farmer is linked to the technical manager roster

    Examples:
      | invitationCode | shareDataConsent | farmerSurfaceHa |
      | COOP-7K2P      | true             | 4.5             |

  # Escenario 2: Código inválido, expirado o revocado
  Scenario Outline: Invalid, expired or revoked code
    Given a POST request to "/api/v1/cooperative-code-redemptions" with invitationCode "<invitationCode>" in status "<codeStatus>"
    When the service processes the redemption transaction
    Then the response status is 409
    And the response follows RFC 7807 indicating the rejection reason without altering the user state

    Examples:
      | invitationCode | codeStatus |
      | COOP-0000      | NOT_FOUND  |
      | COOP-R3D1      | REDEEMED   |
      | COOP-EXP9      | EXPIRED    |
      | COOP-RVK4      | REVOKED    |

  # Escenario 3: Productor ya vinculado a una cooperativa activa
  Scenario Outline: Farmer already linked to an active cooperative
    Given a user "<userId>" with an active corporate affiliation trying to redeem another activation code "<invitationCode>"
    When the subscription aggregator verifies the single-link policy per campaign
    Then the response status is 409
    And the response indicates the account already has an active cooperative sponsorship

    Examples:
      | userId          | invitationCode |
      | usr-farmer-0042 | COOP-9QW3      |
