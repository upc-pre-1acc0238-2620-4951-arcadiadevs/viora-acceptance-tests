Feature: Restoration of archived orchard plot (Orchard)
  As a Client Application Developer
  I want to request the restoration of a decommissioned plot via POST to /api/v1/plots/{plotId}/restore
  so I can reinstate the plot into the active productive inventory without losing history or geometry

  # Escenario 1: Restauración exitosa de cuartel archivado
  Scenario Outline: Successful restoration of archived plot
    Given a POST request to "/api/v1/plots/<plotId>/restore" for a previously archived plot
    When the API validates ownership and reactivates the plot status to "ACTIVE"
    Then the response status is 200
    And the response returns "PlotResponse" with active status and an updated "ETag" header

    Examples:
      | plotId            | previousStatus | targetStatus |
      | plot-archived-001 | ARCHIVED       | ACTIVE       |

  # Escenario 2: Cuartel no encontrado en el sistema
  Scenario Outline: Plot not found during restoration
    Given a POST request to "/api/v1/plots/<plotId>/restore" with a non-existent identifier
    When the API searches the plot repository
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |

  # Escenario 3: Conflicto por cuartel que ya se encuentra activo
  Scenario Outline: Conflict when restoring an already active plot
    Given a POST request to "/api/v1/plots/<plotId>/restore" for a plot already in "ACTIVE" status
    When the service evaluates plot lifecycle transitions
    Then the response status is 409
    And the response indicates that the plot is not archived

    Examples:
      | plotId            | currentStatus |
      | plot-jeronomo-001 | ACTIVE        |
