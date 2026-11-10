Feature: Cooperative member farmer detail query (Cooperative)
  As a Client Application Developer
  I want to query a member of the license via GET to /api/v1/cooperative-members/{id}
  so I can review the member record while they share their data

  # Scenario 1: Successful query
  Scenario Outline: Successful query
    Given a GET request to "/api/v1/cooperative-members/<id>" sent by "<actor>" for a member of the manager license
    When the API reads the member
    Then the response status is 200
    And phone, email and plots are included only while the member shares data

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Scenario 2: Member not found
  Scenario Outline: Member not found
    Given a GET request to "/api/v1/cooperative-members/<id>" sent by "<actor>" for an identifier that is not a member of the license
    When the API searches the member
    Then the response status is 404

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Scenario 3: Request without authentication
  Scenario Outline: Request without authentication
    Given a GET request to "/api/v1/cooperative-members/<id>" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | anonymous-client |

  # Scenario 4: Manager without a license in force
  Scenario Outline: Manager without a license in force
    Given a GET request to "/api/v1/cooperative-members/<id>" sent by "<actor>" from a user who is not a manager with a license in force
    When the API checks the access
    Then the response status is 403

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
