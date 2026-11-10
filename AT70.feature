Feature: Saved assistant answer query (Assistant)
  As a Client Application Developer
  I want to request a saved answer via GET to /api/v1/assistant/answers/{answerId}
  so I can open it from the history with its current freshness

  # Scenario 1: Successful answer query
  Scenario Outline: Successful answer query
    Given a GET request to "/api/v1/assistant/answers/<answerId>" sent by "<actor>" for an own answer of the last ten days
    When the API compares its source data
    Then the response status is 200
    And the response returns the answer with its updated freshness

    Examples:
      | answerId                             | actor           |
      | 0b6a5a3e-5c4f-4b8e-9a35-4b7e3e5f1a10 | usr-farmer-0042 |

  # Scenario 2: Unknown or expired answer
  Scenario Outline: Unknown or expired answer
    Given a GET request to "/api/v1/assistant/answers/<answerId>" sent by "<actor>" for an identifier without a valid answer
    When the API searches the answer
    Then the response status is 404

    Examples:
      | answerId                             | actor           |
      | 0b6a5a3e-5c4f-4b8e-9a35-4b7e3e5f1a10 | usr-farmer-0042 |

  # Scenario 3: Invalid identifier or inactive plan
  Scenario Outline: Invalid identifier or inactive plan
    Given a GET request to "/api/v1/assistant/answers/<answerId>" sent by "<actor>" with a malformed identifier or from a producer without an active plan
    When the API validates the request
    Then the response status is 400
    And 400 applies to malformed identifiers and 403 to inactive plans

    Examples:
      | answerId                             | actor           |
      | 0b6a5a3e-5c4f-4b8e-9a35-4b7e3e5f1a10 | usr-farmer-0042 |
