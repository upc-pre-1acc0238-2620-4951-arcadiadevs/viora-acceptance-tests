Feature: Account email verification (IAM)
  As a Client Application Developer
  I want to send the verification code with the email via POST to /api/v1/auth/email-verifications
  so I can activate the account and obtain the session

  # Scenario 1: Successful verification
  Scenario Outline: Successful verification
    Given a POST request to "/api/v1/auth/email-verifications" sent by "<actor>" with the 6-digit code sent at sign-up
    When the API validates the code
    Then the account is activated and the session is returned

    Examples:
      | actor            |
      | anonymous-client |

  # Scenario 2: Wrong code
  Scenario Outline: Wrong code
    Given a POST request to "/api/v1/auth/email-verifications" sent by "<actor>" with a wrong code
    When the API validates the code
    Then the response status is 422
    And the response indicates the remaining attempts

    Examples:
      | actor            |
      | anonymous-client |
