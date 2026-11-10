Feature: Periodic session token renewal through refresh token (IAM)
  As a Client Application Developer
  I want to send a valid refresh token via POST to /api/v1/auth/refresh-tokens
  so I can renew the session without signing in again

  # Escenario 1: Renovación exitosa de token
  Scenario Outline: Successful token renewal
    Given a POST request to "/api/v1/auth/refresh-tokens" sent by "<actor>" with a valid and not revoked refresh token
    When the API rotates the session tokens
    Then the response status is 200
    And the response returns a new access token and a rotated refresh token

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 2: Refresh token expirado o revocado
  Scenario Outline: Expired or revoked refresh token
    Given a POST request to "/api/v1/auth/refresh-tokens" sent by "<actor>" with an expired or revoked refresh token
    When the API validates the refresh token
    Then the response status is 401
    And the client must authenticate again

    Examples:
      | actor           |
      | usr-farmer-0042 |
