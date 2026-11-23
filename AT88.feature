Feature: Data sharing consent query (Membership)
  As a Client Application Developer
  I want to query a data sharing consent via GET to /api/v1/data-sharing-consents/{id}
  so I can review the detail of an own authorization

  # Scenario 1: Successful query
  Scenario Outline: Successful query
    Given a GET request to "/api/v1/data-sharing-consents/<id>" sent by "<actor>" for an own consent
    When the API reads the consent
    Then the response status is 200

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Scenario 2: Unavailable consent
  Scenario Outline: Unavailable consent
    Given a GET request to "/api/v1/data-sharing-consents/<id>" sent by "<actor>" for a consent that does not belong to the producer
    When the API searches the consent
    Then the response status is 404

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Scenario 3: Request without authentication
  Scenario Outline: Request without authentication
    Given a GET request to "/api/v1/data-sharing-consents/<id>" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | anonymous-client |

  # Scenario 4: User without the producer role
  Scenario Outline: User without the producer role
    Given a GET request to "/api/v1/data-sharing-consents/<id>" sent by "<actor>" from a user who is not a producer
    When the API checks the role
    Then the response status is 403

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |
