Feature: Assistant answer history query (Assistant)
  As a Client Application Developer
  I want to list the latest answers with a limit via GET to /api/v1/assistant/answers
  so I can show the recent answers and their freshness

  # Scenario 1: Valid answers list
  Scenario Outline: Valid answers list
    Given a GET request to "/api/v1/assistant/answers?limit=<limit>" sent by "<actor>" with limit 10
    When the API reads the answers of the last ten days
    Then the response status is 200
    And the answers come newest first with freshness UP_TO_DATE or STALE

    Examples:
      | limit | actor           |
      | 10    | usr-farmer-0042 |

  # Scenario 2: Limit out of range
  Scenario Outline: Limit out of range
    Given a GET request to "/api/v1/assistant/answers?limit=<limit>" sent by "<actor>" with a limit outside 1 to 10
    When the API validates the parameter
    Then the response status is 400

    Examples:
      | limit | actor           |
      | 10    | usr-farmer-0042 |

  # Scenario 3: Producer without an active plan
  Scenario Outline: Producer without an active plan
    Given a GET request to "/api/v1/assistant/answers?limit=<limit>" sent by "<actor>" from a producer without an active plan
    When the API checks the subscription
    Then the response status is 403

    Examples:
      | limit | actor           |
      | 10    | usr-farmer-0042 |
