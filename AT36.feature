Feature: Password update for an authenticated session (IAM)
  As a Client Application Developer
  I want to change the password with the current and the new password via PATCH to /api/v1/auth/passwords
  so I can keep the account secure

  # Escenario 1: Actualización exitosa de contraseña
  Scenario Outline: Successful password update
    Given a PATCH request to "/api/v1/auth/passwords" sent by "<actor>" with current password, new password and confirmation
    When the API verifies the current password and stores the new one
    Then the response status is 204

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 2: Contraseña actual incorrecta
  Scenario Outline: Wrong current password
    Given a PATCH request to "/api/v1/auth/passwords" sent by "<actor>" with a wrong current password
    When the API verifies the current password
    Then the response status is 400
    And the problem detail indicates the credential mismatch

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 3: Nueva contraseña no cumple políticas de complejidad
  Scenario Outline: New password does not meet complexity policies
    Given a PATCH request to "/api/v1/auth/passwords" sent by "<actor>" with a new password that is too weak
    When the API validates the new password
    Then the response status is 400
    And the response details the broken rule

    Examples:
      | actor           |
      | usr-farmer-0042 |
