Feature: Erroneous harvest record deletion in phenological history (Phenology)
  As a Client Application Developer
  I want to delete an erroneously recorded harvest yield via DELETE to /api/v1/plots/{plotId}/harvest-records/{recordId}
  so I can purge anomalous data from history and recompute the plot BBI alternation index

  # Escenario 1: Eliminación exitosa de registro de cosecha
  Scenario Outline: Successful harvest record deletion
    Given a DELETE request to "/api/v1/plots/<plotId>/harvest-records/<recordId>"
    When the API validates ownership, removes the erroneous record, and reactively recomputes the BBI index
    Then the response status is 200

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

  # Escenario 3: Revisión desactualizada del registro (HTTP 412 Precondition Failed)
  Scenario Outline: Outdated record revision
    Given a DELETE request to "/api/v1/plots/<plotId>/harvest-records/<id>" sent by "<actor>" with an If-Match header that does not match the current record version
    When the API compares the revision
    Then the response status is 412

    Examples:
      | plotId          | id                                   | actor           |
      | plot-yarada-001 | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
