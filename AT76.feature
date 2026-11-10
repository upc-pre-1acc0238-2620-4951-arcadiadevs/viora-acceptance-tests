Feature: Password reset link validity check (IAM)
  As a Client Application Developer
  I want to check a password reset link via GET to /api/v1/auth/password-reset-tokens/{token}
  so I can know whether it can be used without consuming it

  # Escenario 1: Enlace vigente
  Scenario Outline: Valid link
    Given a GET request to "/api/v1/auth/password-reset-tokens/<token>" sent by "<actor>" for a usable link
    When the API validates the link without consuming it
    Then the response status is 204

    Examples:
      | token        | actor            |
      | a7f3c9e1b2d4 | anonymous-client |

  # Escenario 2: Enlace no disponible
  Scenario Outline: Unavailable link
    Given a GET request to "/api/v1/auth/password-reset-tokens/<token>" sent by "<actor>" for an expired, used or replaced link
    When the API validates the link
    Then the response status is 404

    Examples:
      | token        | actor            |
      | a7f3c9e1b2d4 | anonymous-client |
