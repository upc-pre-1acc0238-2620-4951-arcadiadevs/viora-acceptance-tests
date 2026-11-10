Feature: User authentication and access token issuance with role (IAM)
  As a Client Application Developer
  I want to authenticate with email and password via POST to /api/v1/auth/sign-in
  so I can obtain the access and refresh tokens of the session

  # Escenario 1: Autenticación exitosa
  Scenario Outline: Successful authentication
    Given a POST request to "/api/v1/auth/sign-in" sent by "<actor>" with valid email and password
    When the API verifies the credentials
    Then the response status is 200
    And the response returns the access token, the refresh token and the token type

    Examples:
      | actor            |
      | anonymous-client |

  # Escenario 2: Credenciales incorrectas
  Scenario Outline: Wrong credentials
    Given a POST request to "/api/v1/auth/sign-in" sent by "<actor>" with a wrong password or an unregistered email
    When the API verifies the credentials
    Then the response status is 401
    And the response returns a generic authentication error

    Examples:
      | actor            |
      | anonymous-client |
