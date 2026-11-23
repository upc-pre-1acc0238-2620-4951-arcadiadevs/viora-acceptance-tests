Feature: Global plot sampling overview query for plot picker (Thinning)
  As a Client Application Developer
  I want to query the sampling state of every plot of the campaign via GET to /api/v1/samplings
  so I can show the coverage of each plot in the plot picker

  # Scenario 1: Successful sampling coverage and status query
  Scenario Outline: Successful sampling coverage and status query
    Given a GET request to "/api/v1/samplings?campaignYear=<campaignYear>" sent by "<actor>" with an optional campaign year
    When the API reads the sampling state of the plots
    Then the response status is 200
    And the response returns the overview of each plot

    Examples:
      | campaignYear | actor           |
      | 2026         | usr-farmer-0042 |

  # Scenario 2: Invalid campaign year
  Scenario Outline: Invalid campaign year
    Given a GET request to "/api/v1/samplings?campaignYear=<campaignYear>" sent by "<actor>" with a campaign year below 2000
    When the API validates the parameter
    Then the response status is 400

    Examples:
      | campaignYear | actor           |
      | 2026         | usr-farmer-0042 |
