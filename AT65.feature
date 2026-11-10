Feature: Cooperative invitation code preview (Membership)
  As a Client Application Developer
  I want to preview what an invitation code offers via POST to /api/v1/cooperative-code-previews
  so I can show the conditions and the consent text before redeeming it

  # Scenario 1: Successful preview
  Scenario Outline: Successful preview
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" with a valid code
    When the API evaluates the code without consuming it
    Then the response status is 200
    And the response returns the organization, manager, quota, plan end and consent version

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Scenario 2: Code that cannot be used
  Scenario Outline: Code that cannot be used
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" with an unknown, expired, redeemed or revoked code
    When the API evaluates the code
    Then the response status is 400

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Scenario 3: Producer with an active subscription
  Scenario Outline: Producer with an active subscription
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" from a producer who already has an active subscription
    When the API checks the subscription
    Then the response status is 409

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Scenario 4: Request without authentication
  Scenario Outline: Request without authentication
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | actor            |
      | anonymous-client |

  # Scenario 5: User without the producer role
  Scenario Outline: User without the producer role
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" from a user who is not a producer
    When the API checks the role
    Then the response status is 403

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Scenario 6: Too many failed attempts
  Scenario Outline: Too many failed attempts
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" after too many failed attempts
    When the API applies the attempt limit
    Then the response status is 429
    And the response includes the Retry-After header

    Examples:
      | actor           |
      | usr-farmer-0042 |
