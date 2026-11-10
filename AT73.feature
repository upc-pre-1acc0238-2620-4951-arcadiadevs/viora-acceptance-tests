Feature: Permanent account deletion (IAM)
  As a Client Application Developer
  I want to delete the account with its password via POST to /api/v1/auth/account-deletions
  so I can remove the data of the authenticated user for good

  # Escenario 1: Eliminación exitosa
  Scenario Outline: Successful deletion
    Given a POST request to "/api/v1/auth/account-deletions" sent by "<actor>" with the correct password
    When the API deletes the profile, plots, records, settlements, dossiers, subscriptions and sessions
    Then the response status is 204

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 2: Contraseña incorrecta
  Scenario Outline: Wrong password
    Given a POST request to "/api/v1/auth/account-deletions" sent by "<actor>" with a wrong password
    When the API verifies the password
    Then the response status is 422

    Examples:
      | actor           |
      | usr-farmer-0042 |
