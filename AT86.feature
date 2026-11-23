Feature: Member release from the institutional license (Membership)
  As a Client Application Developer
  I want to release a member with memberId via POST to /api/v1/cooperative-licenses/{id}/member-releases
  so I can stop the manager access to the member data and free the seat after the grace period

  # Scenario 1: Successful release
  Scenario Outline: Successful release
    Given a POST request to "/api/v1/cooperative-licenses/<id>/member-releases" sent by "<actor>" for a member of the manager license
    When the API records the release
    Then the response status is 200
    And the manager stops reading the member data at once

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Scenario 2: Invalid member
  Scenario Outline: Invalid member
    Given a POST request to "/api/v1/cooperative-licenses/<id>/member-releases" sent by "<actor>" with an invalid memberId
    When the API validates the request
    Then the response status is 400

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Scenario 3: License or member not found
  Scenario Outline: License or member not found
    Given a POST request to "/api/v1/cooperative-licenses/<id>/member-releases" sent by "<actor>" for a foreign license or a user who is not a member
    When the API searches the member
    Then the response status is 404

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Scenario 4: Member already released
  Scenario Outline: Member already released
    Given a POST request to "/api/v1/cooperative-licenses/<id>/member-releases" sent by "<actor>" for a member already released
    When the API checks the member status
    Then the response status is 409

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Scenario 5: Request without authentication
  Scenario Outline: Request without authentication
    Given a POST request to "/api/v1/cooperative-licenses/<id>/member-releases" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | anonymous-client |

  # Scenario 6: User without the technical manager role
  Scenario Outline: User without the technical manager role
    Given a POST request to "/api/v1/cooperative-licenses/<id>/member-releases" sent by "<actor>" from a user who is not a technical manager
    When the API checks the role
    Then the response status is 403

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
