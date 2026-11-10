Feature: Field fruit set sampling recording and synchronization (Thinning)
  As a Client Application Developer
  I want to submit tree sampling counts via POST to /api/v1/plots/{plotId}/samplings with optional trunk diameter
  so I can synchronize offline samplings and compute plot crop load without blocking if trunk diameter is omitted

  # Scenario 1: Successful sampling batch synchronization with or without trunk diameter
  Scenario Outline: Successful sampling batch synchronization with or without trunk diameter
    Given a POST request to "/api/v1/plots/<plotId>/samplings" with body containing <campaignYear>, "<samplingDate>", <shootsCount>, <fruitsCount> and <trunkDiameterMm>
    When the API validates counts, allows optional trunk diameter and computes mean fruit set rate
    Then the response status is 201
    And the response returns "SamplingBatchResponse" with treesSampled, averageFruitPerShoot, cropLoadIndex and statistical sufficiency

    Examples:
      | plotId            | campaignYear | samplingDate | shootsCount | fruitsCount | trunkDiameterMm |
      | plot-jeronomo-001 | 2025         | 2025-11-15   | 20          | 140         | 120             |
      | plot-jeronomo-001 | 2025         | 2025-11-15   | 20          | 135         | null            |

  # Scenario 2: Rejection due to negative counts or biological inconsistency
  Scenario Outline: Rejection due to negative counts or biological inconsistency
    Given a POST request to "/api/v1/plots/<plotId>/samplings" with invalid or negative counts: <shootsCount>, <fruitsCount>
    When the validation service evaluates agronomic batch integrity
    Then the response status is 400
    And the response indicates sampling batch constraint violations

    Examples:
      | plotId            | shootsCount | fruitsCount | reason                   |
      | plot-jeronomo-001 | -5          | 100         | negative shoot count     |
      | plot-jeronomo-001 | 10          | 5000        | biologically impossible  |

  # Scenario 3: Plot not found for sampling submission
  Scenario Outline: Plot not found for sampling submission
    Given a POST request to "/api/v1/plots/<plotId>/samplings" with a non-existent plotId
    When the API attempts to associate the sampling batch with the plot
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |

  # Scenario 4: Duplicated trees or conflicting batch
  Scenario Outline: Duplicated trees or conflicting batch
    Given a POST request to "/api/v1/plots/<plotId>/samplings" sent by "<actor>" with duplicated tree identifiers in the round or a conflicting batch
    When the API validates the sampling round
    Then the response status is 409

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |
