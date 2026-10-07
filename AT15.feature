Feature: Plot removal and logical soft delete from inventory (Orchard)
  As a Client Application Developer
  I want to request the removal of a plot from the API
  so I can deactivate plots registered by error or decommissioned from production

  # Escenario 1: Eliminación exitosa
  Scenario Outline: Successful plot soft delete
    Given a DELETE request to "/api/v1/plots/<plotId>" issued by the plot owner
    When the API validates ownership and executes soft delete of the plot
    Then the response status is 204

    Examples:
      | plotId            |
      | plot-jeronomo-001 |

  # Escenario 2: Parcela ajena
  Scenario Outline: Unauthorized deletion of another user's plot
    Given a DELETE request to "/api/v1/plots/<plotId>" belonging to another user
    When the API verifies permissions
    Then the response status is 403

    Examples:
      | plotId            | requesterRole  |
      | plot-other-999    | ROLE_PRODUCTOR |
