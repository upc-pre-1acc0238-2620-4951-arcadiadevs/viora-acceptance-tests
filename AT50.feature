Feature: Completion of an incident agronomic mitigation step (Telemetry)
  As a Client Application Developer
  I want to complete a mitigation step of an incident via PUT to /api/v1/agroclimatic-incidents/{incidentId}/mitigation-steps/{stepId}
  so I can record the field response and update the incident progress

  # Escenario 1: Completado exitoso de paso y avance del incidente (HTTP 200 OK)
  Scenario Outline: Successful step completion and incident progress
    Given a PUT request to "/api/v1/agroclimatic-incidents/<incidentId>/mitigation-steps/<stepId>" sent by "<actor>" with optional notes
    When the API completes the step
    Then the response status is 200
    And the response returns the updated mitigation progress

    Examples:
      | incidentId     | stepId  | actor           |
      | inc-frost-0003 | step-02 | usr-farmer-0042 |

  # Escenario 2: Notas de ejecución exceden la longitud permitida (HTTP 400 Bad Request)
  Scenario Outline: Execution notes too long
    Given a PUT request to "/api/v1/agroclimatic-incidents/<incidentId>/mitigation-steps/<stepId>" sent by "<actor>" with notes longer than 500 characters
    When the API validates the request body
    Then the response status is 400

    Examples:
      | incidentId     | stepId  | actor           |
      | inc-frost-0003 | step-02 | usr-farmer-0042 |

  # Escenario 3: Incidente o paso no encontrado (HTTP 404 Not Found)
  Scenario Outline: Incident or step not found
    Given a PUT request to "/api/v1/agroclimatic-incidents/<incidentId>/mitigation-steps/<stepId>" sent by "<actor>" for an unknown incident or a step outside the incident
    When the API searches the step
    Then the response status is 404

    Examples:
      | incidentId     | stepId  | actor           |
      | inc-frost-0003 | step-02 | usr-farmer-0042 |
