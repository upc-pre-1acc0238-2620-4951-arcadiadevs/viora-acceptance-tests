Feature: Plot inventory listing and incremental delta synchronization (Orchard)
  As a Client Application Developer
  I want to query the plot inventory with timestamp support
  so I can update the local SQLite database via efficient delta synchronization

  # Escenario 1: Consulta y sincronización incremental
  Scenario Outline: Query and incremental synchronization
    Given a GET request to "/api/v1/plots" with optional parameter "?updatedSince=<timestamp>"
    When the API filters active user plots modified after said timestamp
    Then the response status is 200
    And the response returns an array of updated "PlotResource" objects

    Examples:
      | timestamp            | expectedPlots |
      | 2026-09-01T00:00:00Z | 3             |
      | 2026-10-01T12:00:00Z | 1             |

  # Escenario 2: Acceso no autorizado a predios ajenos
  Scenario Outline: Unauthorized access to plots of another user
    Given a GET request to "/api/v1/plots" with parameter "?userId=<targetUserId>" belonging to another farmer without technical manager privileges
    When the API validates access permissions
    Then the response status is 403

    Examples:
      | targetUserId   | requesterRole  |
      | usr-999-other  | ROLE_PRODUCTOR |
