Feature: User account credential registration and role assignment (IAM)
  As a Client Application Developer
  I want to send the sign-up data with email, password, full name, E.164 phone and institutional role via POST to /api/v1/auth/sign-up
  so I can create the user account with an encrypted password and its assigned role

  # Scenario 1: Successful account creation with technical manager or producer role
  Scenario Outline: Successful account creation with technical manager or producer role
    Given a POST request to "/api/v1/auth/sign-up" sent by "<actor>" with email, password, full name, phone and role
    When the API validates the data and stores the account
    Then the response status is 201
    And the response returns the created account with its role

    Examples:
      | actor            |
      | anonymous-client |

  # Scenario 2: Email or phone already registered
  Scenario Outline: Email or phone already registered
    Given a POST request to "/api/v1/auth/sign-up" sent by "<actor>" with an email or phone already used by another account
    When the API checks identity uniqueness
    Then the response status is 409
    And the problem detail names the duplicated attribute

    Examples:
      | actor            |
      | anonymous-client |

  # Scenario 3: Password or phone does not meet the validation policies
  Scenario Outline: Password or phone does not meet the validation policies
    Given a POST request to "/api/v1/auth/sign-up" sent by "<actor>" with a short password or a phone outside the E.164 format
    When the API validates the request body
    Then the response status is 400
    And the response lists the constraint violations

    Examples:
      | actor            |
      | anonymous-client |
