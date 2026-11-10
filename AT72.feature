Feature: User sign out (IAM)
  As a Client Application Developer
  I want to close the session with the refresh token via POST to /api/v1/auth/sign-out
  so I can prevent the session from being renewed again

  # Escenario 1: Cierre de sesión
  Scenario Outline: Sign out
    Given a POST request to "/api/v1/auth/sign-out" sent by "<actor>" with a valid, unknown or already closed refresh token
    When the API closes the session
    Then the response status is 204

    Examples:
      | actor           |
      | usr-farmer-0042 |
