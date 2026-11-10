Feature: Temporary postponement of agroclimatic incident notifications (Telemetry)
  As a Client Application Developer
  I want to postpone the notifications of an incident for some hours via POST to /api/v1/agroclimatic-incidents/{incidentId}/postponements
  so I can silence the alerts temporarily without resolving the incident

  # Escenario 1: Postergación exitosa de notificaciones del incidente (HTTP 200 OK)
  Scenario Outline: Successful incident notification postponement
    Given a POST request to "/api/v1/agroclimatic-incidents/<incidentId>/postponements" sent by "<actor>" with snooze hours between 1 and 72
    When the API postpones the incident
    Then the response status is 200
    And the incident is SNOOZED until the scheduled date

    Examples:
      | incidentId     | actor           |
      | inc-frost-0003 | usr-farmer-0042 |

  # Escenario 2: Duración de postergación fuera de rango permitido (HTTP 400 Bad Request)
  Scenario Outline: Postponement duration out of range
    Given a POST request to "/api/v1/agroclimatic-incidents/<incidentId>/postponements" sent by "<actor>" with snooze hours below 1 or above 72
    When the API validates the duration
    Then the response status is 400

    Examples:
      | incidentId     | actor           |
      | inc-frost-0003 | usr-farmer-0042 |

  # Escenario 3: Incidente no encontrado (HTTP 404 Not Found)
  Scenario Outline: Incident not found
    Given a POST request to "/api/v1/agroclimatic-incidents/<incidentId>/postponements" sent by "<actor>" for an unknown incident
    When the API searches the incident
    Then the response status is 404

    Examples:
      | incidentId     | actor           |
      | inc-frost-0003 | usr-farmer-0042 |
