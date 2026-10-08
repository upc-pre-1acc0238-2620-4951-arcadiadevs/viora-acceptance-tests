Feature: Erroneous harvest record deletion in phenological history (Phenology)
  As a Client Application Developer
  I want to delete an erroneously recorded harvest yield via DELETE to /api/v1/plots/{plotId}/harvest-records/{recordId}
  so I can purge anomalous data from history and recompute the plot BBI alternation index

  # Escenario 1: Eliminación exitosa de registro de cosecha
  Scenario Outline: Successful harvest record deletion
    Given a DELETE request to "/api/v1/plots/<plotId>/harvest-records/<recordId>"
    When the API validates ownership, removes the erroneous record, and reactively recomputes the BBI index
    Then the response status is 204

    Examples:
      | plotId            | recordId   |
      | plot-jeronomo-001 | rec-2023-1 |

  # Escenario 2: Registro de cosecha o cuartel no encontrado
  Scenario Outline: Harvest record or plot not found for deletion
    Given a DELETE request with a non-existent plotId or recordId: "<plotId>", "<recordId>"
    When the API verifies record existence in the database
    Then the response status is 404

    Examples:
      | plotId                | recordId           |
      | plot-non-existent-999 | rec-2023-1         |
      | plot-jeronomo-001     | rec-non-existent-9 |
