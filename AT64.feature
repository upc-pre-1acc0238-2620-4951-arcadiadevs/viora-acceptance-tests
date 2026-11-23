Feature: Manager master code redemption for technical manager activation (Membership)
  As a Client Application Developer
  I want to redeem the activation code of the manager via POST to /api/v1/manager-code-redemptions
  so I can put the authenticated technical manager in charge of the license

  # Scenario 1: Successful master code redemption
  Scenario Outline: Successful master code redemption
    Given a POST request to "/api/v1/manager-code-redemptions" sent by "<actor>" with a valid code
    When the API consumes the code and assigns the license to the manager
    Then the response status is 201

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Scenario 2: Code that cannot be redeemed
  Scenario Outline: Code that cannot be redeemed
    Given a POST request to "/api/v1/manager-code-redemptions" sent by "<actor>" with an unknown, expired, used or revoked code
    When the API processes the redemption
    Then the response status is 400

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Scenario 3: Manager with a license in force
  Scenario Outline: Manager with a license in force
    Given a POST request to "/api/v1/manager-code-redemptions" sent by "<actor>" from a manager already in charge of a license in force
    When the API checks the manager licenses
    Then the response status is 409

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Scenario 4: Request without authentication
  Scenario Outline: Request without authentication
    Given a POST request to "/api/v1/manager-code-redemptions" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | actor            |
      | anonymous-client |

  # Scenario 5: User without the technical manager role
  Scenario Outline: User without the technical manager role
    Given a POST request to "/api/v1/manager-code-redemptions" sent by "<actor>" from a user who is not a technical manager
    When the API checks the role
    Then the response status is 403

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Scenario 6: Too many failed attempts
  Scenario Outline: Too many failed attempts
    Given a POST request to "/api/v1/manager-code-redemptions" sent by "<actor>" after too many failed attempts
    When the API applies the attempt limit
    Then the response status is 429
    And the response includes the Retry-After header

    Examples:
      | actor            |
      | usr-manager-0007 |
