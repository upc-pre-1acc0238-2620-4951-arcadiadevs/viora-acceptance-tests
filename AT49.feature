Feature: Temporary postponement of agroclimatic incident notifications (Telemetry)
  As a Client Application Developer
  I want to postpone incident notifications via POST to /api/v1/agroclimatic-incidents/{incidentId}/snooze with snoozeHours
  so I can temporarily silence push alerts during the defined window without resolving the alert

  # Escenario 1: Postergación exitosa de notificaciones del incidente
  Scenario Outline: Successful postponement of incident notifications
    Given a POST request to "/api/v1/agroclimatic-incidents/<incidentId>/snooze" with snoozeHours between 1 and 72: <snoozeHours>
    When the API validates incident status, calculates snooze expiration and suspends push dispatches
    Then the response status is 200
    And the response returns "AgroclimaticIncidentResponse" with status "SNOOZED" and scheduled "snoozeUntil"

    Examples:
      | incidentId     | snoozeHours |
      | inc-frost-2026 | 6           |

  # Escenario 2: Duración de postergación fuera de rango permitido
  Scenario Outline: Snooze duration outside permissible range
    Given a POST request with snoozeHours less than 1 or greater than 72: <snoozeHours>
    When the API validates requested hours
    Then the response status is 400

    Examples:
      | incidentId     | snoozeHours | reason                   |
      | inc-frost-2026 | 0           | snooze hours below min 1 |
      | inc-frost-2026 | 80          | snooze hours above max 72|

  # Escenario 3: Incidente no encontrado
  Scenario Outline: Incident not found for postponement
    Given a POST request to "/api/v1/agroclimatic-incidents/<incidentId>/snooze" with non-existent incidentId
    When the service queries the incident repository
    Then the response status is 404

    Examples:
      | incidentId            | snoozeHours |
      | inc-non-existent-9999 | 12          |
