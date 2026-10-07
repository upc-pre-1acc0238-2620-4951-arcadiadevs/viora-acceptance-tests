Feature: Completion of incident agronomic mitigation step (Telemetry)
  As a Client Application Developer
  I want to record the execution of a mitigation protocol step via POST to /api/v1/agroclimatic-incidents/{incidentId}/mitigation-steps/{stepId}/complete
  so I can record response tasks in the field and update incident resolution status

  # Escenario 1: Completado exitoso de paso y avance del incidente
  Scenario Outline: Successful completion of mitigation step
    Given a POST request to "/api/v1/agroclimatic-incidents/<incidentId>/mitigation-steps/<stepId>/complete" with optional notes: "<notes>"
    When the API validates step ownership, marks it as "COMPLETED" and evaluates if all steps are concluded
    Then the response status is 200
    And the response returns "AgroclimaticIncidentDetailResponse" with step marked completed and updated mitigation progress

    Examples:
      | incidentId     | stepId | notes                                              | targetIncidentStatus |
      | inc-frost-2026 | step-1 | Micro-sprinklers activated at 03:00 AM on sector A | IN_MITIGATION        |

  # Escenario 2: Notas de ejecución exceden la longitud permitida
  Scenario Outline: Execution notes exceed maximum permissible length
    Given a POST request whose notes field exceeds 500 characters
    When the validation layer processes the body
    Then the response status is 400
    And the response message indicates length violation

    Examples:
      | incidentId     | stepId | reason                          |
      | inc-frost-2026 | step-1 | notes field exceeds 500 length  |

  # Escenario 3: Incidente o paso no encontrado
  Scenario Outline: Incident or step not found for completion
    Given a POST request towards a non-existent incidentId or stepId: "<incidentId>", "<stepId>"
    When the API performs persistence lookup
    Then the response status is 404

    Examples:
      | incidentId            | stepId            |
      | inc-non-existent-9999 | step-1            |
      | inc-frost-2026        | step-non-existent |
