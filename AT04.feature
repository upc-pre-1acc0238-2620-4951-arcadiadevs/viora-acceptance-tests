Feature: Authenticated user profile query (Profiles)
  As a Client Application Developer
  I want to request the profile of the authenticated user via GET to /api/v1/profiles/{userId}
  so I can show the personal and contact data of the account

  # Scenario 1: Successful own profile query
  Scenario Outline: Successful own profile query
    Given a GET request to "/api/v1/profiles/<userId>" sent by "<actor>" with a valid bearer token for the same user
    When the API reads the profile
    Then the response status is 200
    And the response returns the profile with its contact data

    Examples:
      | userId          | actor           |
      | usr-farmer-0042 | usr-farmer-0042 |

  # Scenario 2: Attempt to query another user profile
  Scenario Outline: Attempt to query another user profile
    Given a GET request to "/api/v1/profiles/<userId>" sent by "<actor>" for a user different from the authenticated one
    When the API checks the ownership
    Then the response status is 403

    Examples:
      | userId          | actor           |
      | usr-farmer-0042 | usr-farmer-0042 |

  # Scenario 3: Unknown user
  Scenario Outline: Unknown user
    Given a GET request to "/api/v1/profiles/<userId>" sent by "<actor>" for an unregistered user identifier
    When the API searches the profile
    Then the response status is 404

    Examples:
      | userId          | actor           |
      | usr-farmer-0042 | usr-farmer-0042 |
