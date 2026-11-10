Feature: Chronological events and agronomic thinning log query (Thinning)
  As a Client Application Developer
  I want to query the thinning events with optional plot and campaign filters via GET to /api/v1/thinning-events
  so I can show every sampling, prescription and confirmation in chronological order

  # Scenario 1: Successful chronological log query
  Scenario Outline: Successful chronological log query
    Given a GET request to "/api/v1/thinning-events?plotId=<plotId>&campaignYear=<campaignYear>" sent by "<actor>" with optional plot and campaign filters
    When the API reads the thinning events
    Then the response status is 200
    And the response returns the events in chronological order

    Examples:
      | plotId          | campaignYear | actor           |
      | plot-yarada-001 | 2026         | usr-farmer-0042 |

  # Scenario 2: Plot not found
  Scenario Outline: Plot not found
    Given a GET request to "/api/v1/thinning-events?plotId=<plotId>&campaignYear=<campaignYear>" sent by "<actor>" with an unknown plot identifier
    When the API searches the plot
    Then the response status is 404

    Examples:
      | plotId          | campaignYear | actor           |
      | plot-yarada-001 | 2026         | usr-farmer-0042 |
