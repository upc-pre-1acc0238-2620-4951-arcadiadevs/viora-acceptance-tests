Feature: Plot field notes query (Orchard)
  As a Client Application Developer
  I want to list the notes of a plot via GET to /api/v1/plots/{plotId}/field-notes
  so I can review the observations recorded on the plot

  # Scenario 1: Notes list
  Scenario Outline: Notes list
    Given a GET request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" for an own plot
    When the API reads the notes
    Then the response status is 200
    And the notes come newest first or as an empty list

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Scenario 2: Plot of another producer
  Scenario Outline: Plot of another producer
    Given a GET request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" for a plot of another producer
    When the API checks the ownership
    Then the response status is 403

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Scenario 3: Plot not found
  Scenario Outline: Plot not found
    Given a GET request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" for an unknown plot
    When the API searches the plot
    Then the response status is 404

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |
