Feature: Data sharing consent withdrawal (Membership)
  As a Client Application Developer
  I want to withdraw a data sharing consent via POST to /api/v1/data-sharing-consents/{id}/withdrawals
  so I can stop sharing the data with the cooperative

  # Scenario 1: Successful withdrawal
  Scenario Outline: Successful withdrawal
    Given a POST request to "/api/v1/data-sharing-consents/<id>/withdrawals" sent by "<actor>" for an active consent
    When the API records the withdrawal
    Then the response status is 200
    And the manager stops reading the data and the sponsored plan stays until its end

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Scenario 2: Unavailable consent
  Scenario Outline: Unavailable consent
    Given a POST request to "/api/v1/data-sharing-consents/<id>/withdrawals" sent by "<actor>" for a consent that does not belong to the producer
    When the API searches the consent
    Then the response status is 404

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Scenario 3: Consent not active
  Scenario Outline: Consent not active
    Given a POST request to "/api/v1/data-sharing-consents/<id>/withdrawals" sent by "<actor>" for a withdrawn consent or one ended with its plan
    When the API checks the consent status
    Then the response status is 409

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Scenario 4: Request without authentication
  Scenario Outline: Request without authentication
    Given a POST request to "/api/v1/data-sharing-consents/<id>/withdrawals" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | anonymous-client |

  # Scenario 5: User without the producer role
  Scenario Outline: User without the producer role
    Given a POST request to "/api/v1/data-sharing-consents/<id>/withdrawals" sent by "<actor>" from a user who is not a producer
    When the API checks the role
    Then the response status is 403

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |
