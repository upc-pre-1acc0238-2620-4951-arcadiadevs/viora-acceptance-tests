Feature: Technical thinning prescription and phenological window query (Thinning)
  As a Client Application Developer
  I want to query active thinning prescription via GET to /api/v1/plots/{plotId}/thinning-prescriptions/active
  so I can display recommended removal percentage, window dates and explicit blockers if data is missing

  # Escenario 1: Consulta exitosa de prescripción activa o bloqueadores diagnósticos
  Scenario Outline: Successful prescription query or diagnostic blockers
    Given a GET request to "/api/v1/plots/<plotId>/thinning-prescriptions/active" with route parameter plotId
    When the API evaluates sampling representativeness and full bloom date for the plot
    Then the response status is 200
    And the response returns "ThinningPrescriptionResponse" with status, targetRemovalPercentage, window dates and blockers list

    Examples:
      | plotId            | expectedStatus | expectedRemoval | hasBlockers |
      | plot-jeronomo-001 | ISSUED         | 25.0            | false       |
      | plot-scarce-002   | BLOCKED        | 0.0             | true        |

  # Escenario 2: Cuartel no encontrado o sin prescripción activa
  Scenario Outline: Plot not found or without active prescription
    Given a GET request to "/api/v1/plots/<plotId>/thinning-prescriptions/active" with non-existent or inactive plotId
    When the application service queries thinning context
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |
