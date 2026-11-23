Feature: Producer thinning prescriptions query (Thinning)
  As a Client Application Developer
  I want to list the prescriptions with an optional campaign year via GET to /api/v1/thinning-prescriptions
  so I can review the thinning status of every active plot

  # Scenario 1: Prescriptions list
  Scenario Outline: Prescriptions list
    Given a GET request to "/api/v1/thinning-prescriptions?campaignYear=<campaignYear>" sent by "<actor>" from a producer
    When the API reads the prescription of each active plot of the campaign
    Then the response status is 200
    And plots never sampled are not listed

    Examples:
      | campaignYear | actor           |
      | 2026         | usr-farmer-0042 |

  # Scenario 2: Invalid campaign year
  Scenario Outline: Invalid campaign year
    Given a GET request to "/api/v1/thinning-prescriptions?campaignYear=<campaignYear>" sent by "<actor>" with an invalid campaign year
    When the API validates the parameter
    Then the response status is 400

    Examples:
      | campaignYear | actor           |
      | 2026         | usr-farmer-0042 |
