Feature: Password reset through a single-use temporary token (IAM)
  As a Client Application Developer
  I want to set a new password with a reset token via PUT to /api/v1/auth/password-reset-tokens/{token}
  so I can recover access to the account

  # Scenario 1: Successful password reset
  Scenario Outline: Successful password reset
    Given a PUT request to "/api/v1/auth/password-reset-tokens/<token>" sent by "<actor>" with new password and confirmation
    When the API consumes the token and stores the new password
    Then the response status is 204
    And every previous session is revoked

    Examples:
      | token        | actor            |
      | a7f3c9e1b2d4 | anonymous-client |

  # Scenario 2: Expired, unknown or used token
  Scenario Outline: Expired, unknown or used token
    Given a PUT request to "/api/v1/auth/password-reset-tokens/<token>" sent by "<actor>" with an invalid or expired token
    When the API validates the token
    Then the response status is 404

    Examples:
      | token        | actor            |
      | a7f3c9e1b2d4 | anonymous-client |

  # Scenario 3: New password equal to the previous one or too weak
  Scenario Outline: New password equal to the previous one or too weak
    Given a PUT request to "/api/v1/auth/password-reset-tokens/<token>" sent by "<actor>" with a password equal to the previous one or too weak
    When the API validates the new password
    Then the response status is 400

    Examples:
      | token        | actor            |
      | a7f3c9e1b2d4 | anonymous-client |
