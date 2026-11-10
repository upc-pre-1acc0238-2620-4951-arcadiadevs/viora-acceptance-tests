Feature: Full bloom observed date registration for phenological calibration (Thinning)
  As a Client Application Developer
  I want to record the full bloom date via PUT to /api/v1/plots/{plotId}/thinning-prescriptions/full-bloom
  so I can calibrate the chronological base and calculate the thinning window before pit hardening

  # Scenario 1: Successful full bloom recording and thinning window update
  Scenario Outline: Successful full bloom recording and thinning window update
    Given a PUT request to "/api/v1/plots/<plotId>/thinning-prescriptions/full-bloom" with campaignYear <campaignYear> and fullBloomDate "<fullBloomDate>"
    When the API validates ownership, verifies valid non-future date, and recalculates window boundaries
    Then the response status is 200
    And the response returns "ThinningPrescriptionResponse" with updated windowOpensOn and windowClosesOn dates

    Examples:
      | plotId            | campaignYear | fullBloomDate |
      | plot-jeronomo-001 | 2025         | 2025-10-20    |

  # Scenario 2: Full bloom date in the future or outside campaign year
  Scenario Outline: Full bloom date in the future or outside campaign year
    Given a PUT request with future date or date mismatching campaign year: <campaignYear>, "<fullBloomDate>"
    When the API validates chronological and biological constraints
    Then the response status is 400

    Examples:
      | plotId            | campaignYear | fullBloomDate | reason               |
      | plot-jeronomo-001 | 2025         | 2030-10-20    | future date          |
      | plot-jeronomo-001 | 2025         | 2024-10-20    | outside campaign year|

  # Scenario 3: Plot not found for full bloom recording
  Scenario Outline: Plot not found for full bloom recording
    Given a PUT request with a non-existent plotId: "<plotId>"
    When the service queries the plot repository
    Then the response status is 404

    Examples:
      | plotId                | campaignYear | fullBloomDate |
      | plot-non-existent-999 | 2025         | 2025-10-20    |
