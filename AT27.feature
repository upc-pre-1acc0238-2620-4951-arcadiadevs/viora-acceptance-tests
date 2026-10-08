Feature: Field thinning execution confirmation and recording (Thinning)
  As a Client Application Developer
  I want to submit thinning execution confirmation via POST to /api/v1/plots/{plotId}/thinning-prescriptions/active/confirmations
  so I can record the field practice, update residual load balance and project commercial COI caliber

  # Escenario 1: Confirmación exitosa con balance de carga y proyección de calibre COI
  Scenario Outline: Successful execution confirmation with load balance and caliber projection
    Given a POST request to "/api/v1/plots/<plotId>/thinning-prescriptions/active/confirmations" with executedDate "<executedDate>", actualRemovalPercentage <actualRemoval>, removedKg <removedKg> and laborCrewSize <crewSize>
    When the API validates fields, records thinning in log, and evaluates caliber projection
    Then the response status is 201
    And the response returns "ExecutionConfirmationResponse" with loadBalance and caliberProjection

    Examples:
      | plotId            | executedDate | actualRemoval | removedKg | crewSize |
      | plot-jeronomo-001 | 2025-12-05   | 25.0          | 450.0     | 4        |

  # Escenario 2: Confirmación con 100 % de remoción y calibre no aplicable
  Scenario Outline: Confirmation with total fruit removal (100%)
    Given a POST request where actualRemovalPercentage is 100.0
    When the API registers full sanitation stripping
    Then the response status is 201
    And the response returns loadBalance zero and caliberProjection status "NOT_APPLICABLE"

    Examples:
      | plotId            | executedDate | actualRemoval | removedKg | crewSize |
      | plot-jeronomo-001 | 2025-12-06   | 100.0         | 1800.0    | 6        |

  # Escenario 3: Porcentaje de remoción fuera de rango o fecha inválida
  Scenario Outline: Removal percentage out of range or future execution date
    Given a POST request with negative or exceeding removal percentage or future date: <actualRemoval>, "<executedDate>"
    When the service validates agronomic domain constraints
    Then the response status is 400

    Examples:
      | plotId            | executedDate | actualRemoval | reason                   |
      | plot-jeronomo-001 | 2025-12-05   | -10.0         | negative removal         |
      | plot-jeronomo-001 | 2025-12-05   | 115.0         | removal exceeds 100%     |
      | plot-jeronomo-001 | 2030-01-01   | 20.0          | future execution date    |

  # Escenario 4: Cuartel o prescripción activa inexistente
  Scenario Outline: Plot or active prescription not found for confirmation
    Given a POST request directed to a plotId without active prescription: "<plotId>"
    When the service queries the thinning aggregate
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |
