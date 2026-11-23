Feature: Early cooperative activation code revocation and quota restitution (Membership)
  As a Client Application Developer
  I want to revoke an available activation code via POST to /api/v1/invitation-codes/{id}/revocations
  so I can void the invitation and return its seat and hectares to the license

  # Scenario 1: Successful revocation and quota restitution
  Scenario Outline: Successful revocation and quota restitution
    Given a POST request to "/api/v1/invitation-codes/<id>/revocations" sent by "<actor>" for an available code of the manager
    When the API revokes the code
    Then the response status is 200
    And the seat and hectares return to the license balance

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Scenario 2: Code already redeemed or inactive
  Scenario Outline: Code already redeemed or inactive
    Given a POST request to "/api/v1/invitation-codes/<id>/revocations" sent by "<actor>" for a redeemed, revoked or expired code
    When the API checks the code status
    Then the response status is 409

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Scenario 3: Access denied for non manager users
  Scenario Outline: Access denied for non manager users
    Given a POST request to "/api/v1/invitation-codes/<id>/revocations" sent by "<actor>" from a user without the technical manager role
    When the API checks the role
    Then the response status is 403

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
