Feature: Data sharing consents query (Membership)
  As a Client Application Developer
  I want to list the data sharing consents via GET to /api/v1/data-sharing-consents
  so I can show the producer who reads their data

  # Scenario 1: Consents list
  Scenario Outline: Consents list
    Given a GET request to "/api/v1/data-sharing-consents" sent by "<actor>" from a producer
    When the API reads the producer consents
    Then the response status is 200
    And each consent shows organization, manager and status

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Scenario 2: Request without authentication
  Scenario Outline: Request without authentication
    Given a GET request to "/api/v1/data-sharing-consents" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | actor            |
      | anonymous-client |

  # Scenario 3: User without the producer role
  Scenario Outline: User without the producer role
    Given a GET request to "/api/v1/data-sharing-consents" sent by "<actor>" from a user who is not a producer
    When the API checks the role
    Then the response status is 403

    Examples:
      | actor            |
      | usr-manager-0007 |
