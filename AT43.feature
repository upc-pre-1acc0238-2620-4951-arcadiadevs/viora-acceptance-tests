Feature: Harvest yield rectification with optimistic concurrency locking (Phenology)
  As a Client Application Developer
  I want to send a yield rectification request via PUT to /api/v1/plots/{plotId}/harvest-records/{recordId}
  so I can correct historical yield discrepancies and reactively recompute the BBI alternation index

  # Scenario 1: Successful harvest yield rectification with BBI recalculation
  Scenario Outline: Successful harvest yield rectification with BBI recalculation
    Given a PUT request to "/api/v1/plots/<plotId>/harvest-records/<recordId>" with If-Match header "<ifMatch>" and body containing <rectifiedYieldKg> and "<rectificationReason>"
    When the API validates ownership, verifies positive yield, updates phenology series, and recalculates BBI
    Then the response status is 200
    And the response returns updated "HarvestRecordResponse" and emits an updated "ETag" header

    Examples:
      | plotId            | recordId   | ifMatch | rectifiedYieldKg | rectificationReason                        |
      | plot-jeronomo-001 | rec-2024-1 | "\"1\"" | 11800            | Official scale ticket adjustment mill #4   |

  # Scenario 2: Inconsistent rectification yield or insufficient reason
  Scenario Outline: Inconsistent rectification yield or insufficient reason
    Given a PUT request to "/api/v1/plots/<plotId>/harvest-records/<recordId>" with non-positive yield or short reason: <rectifiedYieldKg>, "<rectificationReason>"
    When the contract validator processes the request body
    Then the response status is 400

    Examples:
      | plotId            | recordId   | rectifiedYieldKg | rectificationReason | reason                  |
      | plot-jeronomo-001 | rec-2024-1 | -100             | Scale ticket error  | negative yield          |
      | plot-jeronomo-001 | rec-2024-1 | 11500            | typo                | reason under 10 chars   |

  # Scenario 3: Harvest record or plot not found for rectification
  Scenario Outline: Harvest record or plot not found for rectification
    Given a PUT request towards a non-existent plotId or recordId: "<plotId>", "<recordId>"
    When the service queries harvest persistence
    Then the response status is 404

    Examples:
      | plotId                | recordId           |
      | plot-non-existent-999 | rec-2024-1         |
      | plot-jeronomo-001     | rec-non-existent-9 |

  # Scenario 4: Optimistic concurrency conflict during rectification
  Scenario Outline: Optimistic concurrency conflict during rectification
    Given a PUT request where the If-Match header "<ifMatch>" does not match current version
    When the interceptor detects concurrent modification collision
    Then the response status is 412
    And the response prevents outdated overwriting under RFC 7807

    Examples:
      | plotId            | recordId   | ifMatch |
      | plot-jeronomo-001 | rec-2024-1 | "\"0\"" |
