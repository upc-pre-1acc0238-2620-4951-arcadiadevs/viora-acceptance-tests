Feature: Plot update and boundary rectification with optimistic locking (Orchard)
  As a Client Application Developer
  I want to send updated plot data via PUT with route parameter plotId, If-Match header and JSON body
  so I can rectify boundary coordinates, spacing or agronomic attributes while preventing concurrent collision

  # Escenario 1: Actualización exitosa con control de concurrencia
  Scenario Outline: Successful plot update with concurrency control
    Given a PUT request to "/api/v1/plots/<plotId>" with If-Match header "<ifMatch>" and body containing "<name>", "<cultivar>", <plantingYear>, "<spacing>", "<coordinates>" and "<irrigationType>"
    When the API validates ownership, verifies If-Match version, recalculates geodesic area and persists changes
    Then the response status is 200
    And the response returns updated "PlotResponse" with incremented "ETag" header

    Examples:
      | plotId            | ifMatch  | name                 | cultivar | plantingYear | spacing | coordinates                                                                         | irrigationType |
      | plot-jeronomo-001 | "\"1\""  | San Jeronimo Rectified | CRIOLLA | 2018         | 7x5     | [[-70.25,-18.05],[-70.24,-18.05],[-70.24,-18.06],[-70.25,-18.06],[-70.25,-18.05]] | DRIP           |

  # Escenario 2: Conflicto de concurrencia optimista por versión desactualizada
  Scenario Outline: Optimistic concurrency conflict due to stale version
    Given a PUT request to "/api/v1/plots/<plotId>" where If-Match header "<ifMatch>" does not match current version
    When the optimistic concurrency interceptor detects concurrent modification conflict
    Then the response status is 412
    And the response RFC 7807 problem detail indicates precondition failed

    Examples:
      | plotId            | ifMatch  |
      | plot-jeronomo-001 | "\"0\""  |

  # Escenario 3: Parámetros inválidos o inconsistencia en linderos geométricos
  Scenario Outline: Invalid parameters or inconsistent geometric boundaries
    Given a PUT request to "/api/v1/plots/<plotId>" with body containing unclosed coordinates or invalid spacing: "<coordinates>"
    When the contract validator processes the request body
    Then the response status is 400
    And the response details field validation violations

    Examples:
      | plotId            | coordinates                       | reason            |
      | plot-jeronomo-001 | [[-70.25,-18.05],[-70.24,-18.05]] | unclosed polygon  |

  # Escenario 4: Cuartel no encontrado en el inventario
  Scenario Outline: Plot not found in inventory
    Given a PUT request to "/api/v1/plots/<plotId>" with non-existent or archived identifier
    When the domain service queries the plot repository
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |
