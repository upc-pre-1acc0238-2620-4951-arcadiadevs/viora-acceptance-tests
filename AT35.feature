Feature: Initial user profile completion with phone validation (Profiles)
  As a Client Application Developer
  I want to complete the profile with full name, country and phone via PUT to /api/v1/profiles/{userId}
  so I can link the contact data to the account and validate the phone

  # Scenario 1: Successful user profile completion
  Scenario Outline: Successful user profile completion
    Given a PUT request to "/api/v1/profiles/<userId>" sent by "<actor>" with full name, country and phone
    When the API normalizes the phone and stores the profile
    Then the response status is 200
    And the response returns the profile with the normalized phone

    Examples:
      | userId          | actor           |
      | usr-farmer-0042 | usr-farmer-0042 |

  # Scenario 2: Invalid phone number
  Scenario Outline: Invalid phone number
    Given a PUT request to "/api/v1/profiles/<userId>" sent by "<actor>" with a phone that does not fit the country format
    When the API validates the phone
    Then the response status is 400
    And the problem detail indicates the invalid phone

    Examples:
      | userId          | actor           |
      | usr-farmer-0042 | usr-farmer-0042 |

  # Scenario 3: Unauthenticated request or invalid token
  Scenario Outline: Unauthenticated request or invalid token
    Given a PUT request to "/api/v1/profiles/<userId>" sent by "<actor>" without a valid authorization header
    When the security filter checks the request
    Then the response status is 401
    And the profile is not stored

    Examples:
      | userId          | actor            |
      | usr-farmer-0042 | anonymous-client |
