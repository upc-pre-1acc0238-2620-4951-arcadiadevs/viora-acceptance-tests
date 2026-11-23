Feature: Email verification code resend (IAM)
  As a Client Application Developer
  I want to request a new verification code via POST to /api/v1/auth/email-verification-codes
  so I can complete the activation of a pending account

  # Scenario 1: Accepted resend request
  Scenario Outline: Accepted resend request
    Given a POST request to "/api/v1/auth/email-verification-codes" sent by "<actor>" with a pending, unknown or verified email
    When the API processes the request
    Then the response status is 202
    And the response does not reveal whether the email exists

    Examples:
      | actor            |
      | anonymous-client |

  # Scenario 2: Resend too early
  Scenario Outline: Resend too early
    Given a POST request to "/api/v1/auth/email-verification-codes" sent by "<actor>" within 45 seconds of the previous request
    When the API checks the interval
    Then the response status is 429
    And the response includes the Retry-After header

    Examples:
      | actor            |
      | anonymous-client |
