Feature: Partial profile update with phone validation (Profiles)
  As a Client Application Developer
  I want to update the full name, phone or country of the profile via PATCH to /api/v1/profiles/{userId}
  so I can keep the contact data of the account current

  # Scenario 1: Successful update
  Scenario Outline: Successful update
    Given a PATCH request to "/api/v1/profiles/<userId>" sent by "<actor>" with a new full name or phone and country
    When the API validates and stores the changes
    Then the response status is 200
    And the response returns the updated profile

    Examples:
      | userId          | actor           |
      | usr-farmer-0042 | usr-farmer-0042 |

  # Scenario 2: Invalid phone in update
  Scenario Outline: Invalid phone in update
    Given a PATCH request to "/api/v1/profiles/<userId>" sent by "<actor>" with a phone outside the E.164 format
    When the API validates the phone
    Then the response status is 400
    And the previous information is kept

    Examples:
      | userId          | actor           |
      | usr-farmer-0042 | usr-farmer-0042 |

  # Scenario 3: Permission denied on another account
  Scenario Outline: Permission denied on another account
    Given a PATCH request to "/api/v1/profiles/<userId>" sent by "<actor>" for a user different from the authenticated one
    When the API checks the ownership
    Then the response status is 403

    Examples:
      | userId          | actor           |
      | usr-farmer-0042 | usr-farmer-0042 |
