Feature: Intake history query by campaign (Cooperative)
  As a Client Application Developer
  I want to list the intake of each campaign via GET to /api/v1/intake-forecasts
  so I can compare the campaign in progress with the settled harvests of previous campaigns

  # Scenario 1: Intake by campaign query
  Scenario Outline: Intake by campaign query
    Given a GET request to "/api/v1/intake-forecasts" sent by "<actor>" from a technical manager with a license in force
    When the API projects the campaign in progress and adds the settled harvests of past campaigns
    Then the response status is 200
    And the response returns the intake of each campaign

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Scenario 2: Request without authentication
  Scenario Outline: Request without authentication
    Given a GET request to "/api/v1/intake-forecasts" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | actor            |
      | anonymous-client |

  # Scenario 3: Manager without a license in force
  Scenario Outline: Manager without a license in force
    Given a GET request to "/api/v1/intake-forecasts" sent by "<actor>" from a user who is not a manager with a license in force
    When the API checks the access
    Then the response status is 403

    Examples:
      | actor           |
      | usr-farmer-0042 |
