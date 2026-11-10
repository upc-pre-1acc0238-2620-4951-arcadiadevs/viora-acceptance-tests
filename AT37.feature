Feature: Forgotten password reset request by email (IAM)
  As a Client Application Developer
  I want to request a password reset with the account email via POST to /api/v1/auth/password-reset-tokens
  so I can receive a temporary reset link without revealing whether the email exists

  # Escenario 1: Solicitud exitosa de restablecimiento
  Scenario Outline: Successful reset request
    Given a POST request to "/api/v1/auth/password-reset-tokens" sent by "<actor>" with an email
    When the API schedules the reset email
    Then the response status is 202

    Examples:
      | actor            |
      | anonymous-client |

  # Escenario 2: Dirección de correo con formato inválido
  Scenario Outline: Invalid email format
    Given a POST request to "/api/v1/auth/password-reset-tokens" sent by "<actor>" with a value that is not an email
    When the API validates the request body
    Then the response status is 400

    Examples:
      | actor            |
      | anonymous-client |
