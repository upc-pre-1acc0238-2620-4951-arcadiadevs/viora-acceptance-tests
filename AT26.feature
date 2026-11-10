Feature: Technical thinning prescription and phenological window query (Thinning)
  As a Client Application Developer
  I want to query the thinning prescription of a plot via GET to /api/v1/plots/{plotId}/thinning-prescriptions
  so I can show the removal percentage, the intervention window and the blockers

  # Escenario 1: Consulta exitosa de prescripción activa o bloqueadores diagnósticos (HTTP 200 OK)
  Scenario Outline: Successful active prescription or diagnostic blockers query
    Given a GET request to "/api/v1/plots/<plotId>/thinning-prescriptions" sent by "<actor>" for a plot of the producer
    When the API evaluates the prescription of the campaign
    Then the response status is 200
    And the response returns the status, percentage, window and blockers

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 2: Cuartel no encontrado o sin prescripción activa (HTTP 404 Not Found)
  Scenario Outline: Plot not found or without prescription
    Given a GET request to "/api/v1/plots/<plotId>/thinning-prescriptions" sent by "<actor>" for an unknown plot or one without a prescription in the campaign
    When the API searches the prescription
    Then the response status is 404

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |
