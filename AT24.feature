Feature: Field fruit set sampling recording and synchronization (Thinning)
  As a Client Application Developer
  I want to submit tree sampling counts via POST to /api/v1/plots/{plotId}/samplings with optional trunk diameter
  so I can synchronize offline samplings and compute plot crop load without blocking if trunk diameter is omitted

  # Escenario 1: Sincronización exitosa de lote de muestreos con o sin diámetro de tronco
  Scenario Outline: Successful sampling batch synchronization with or without trunk diameter
    Given a POST request to "/api/v1/plots/<plotId>/samplings" with body containing <campaignYear>, "<samplingDate>", <shootsCount>, <fruitsCount> and <trunkDiameterMm>
    When the API validates counts, allows optional trunk diameter and computes mean fruit set rate
    Then the response status is 201
    And the response returns "SamplingBatchResponse" with treesSampled, averageFruitPerShoot, cropLoadIndex and statistical sufficiency

    Examples:
      | plotId            | campaignYear | samplingDate | shootsCount | fruitsCount | trunkDiameterMm |
      | plot-jeronomo-001 | 2025         | 2025-11-15   | 20          | 140         | 120             |
      | plot-jeronomo-001 | 2025         | 2025-11-15   | 20          | 135         | null            |

  # Escenario 2: Rechazo por conteos negativos o incongruencia biológica
  Scenario Outline: Rejection due to negative counts or biological inconsistency
    Given a POST request to "/api/v1/plots/<plotId>/samplings" with invalid or negative counts: <shootsCount>, <fruitsCount>
    When the validation service evaluates agronomic batch integrity
    Then the response status is 400
    And the response indicates sampling batch constraint violations

    Examples:
      | plotId            | shootsCount | fruitsCount | reason                   |
      | plot-jeronomo-001 | -5          | 100         | negative shoot count     |
      | plot-jeronomo-001 | 10          | 5000        | biologically impossible  |

  # Escenario 3: Parcela no encontrada en el repositorio
  Scenario Outline: Plot not found for sampling submission
    Given a POST request to "/api/v1/plots/<plotId>/samplings" with a non-existent plotId
    When the API attempts to associate the sampling batch with the plot
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |
