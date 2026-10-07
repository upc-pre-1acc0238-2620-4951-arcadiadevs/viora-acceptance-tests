Feature: Detailed agroclimatic incident query with trend and mitigation steps (Telemetry)
  As a Client Application Developer
  I want to query exhaustive alert details via GET to /api/v1/agroclimatic-incidents/{incidentId}
  so I can display anomaly time-series, the interactive mitigation checklist and agronomic diagnosis

  # Escenario 1: Consulta detallada de incidente con checklist y curva histórica
  Scenario Outline: Detailed incident query with checklist and trend curve
    Given a GET request to "/api/v1/agroclimatic-incidents/<incidentId>" with route parameter incidentId
    When the API validates incident existence and consolidates telemetry anomaly data with recommendations
    Then the response status is 200
    And the response returns "AgroclimaticIncidentDetailResponse" with description, trend time-series and ordered mitigation steps

    Examples:
      | incidentId     | expectedRiskType | expectedStepCount |
      | inc-frost-2026 | FROST            | 3                 |

  # Escenario 2: Incidente no encontrado en el sistema
  Scenario Outline: Incident not found in system
    Given a GET request towards a non-existent incidentId: "<incidentId>"
    When the API searches persistence
    Then the response status is 404

    Examples:
      | incidentId            |
      | inc-non-existent-9999 |
