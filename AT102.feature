Feature: Sealed dossiers of a plot query (Harvest)
  As a Client Application Developer
  I want to list the sealed dossiers of a plot via GET to /api/v1/plots/{plotId}/agronomic-dossiers
  so I can review the final documents by campaign

  # Scenario 1: Dossiers list
  Scenario Outline: Dossiers list
    Given a GET request to "/api/v1/plots/<plotId>/agronomic-dossiers" sent by "<actor>" for an active plot
    When the API reads the dossiers
    Then the response status is 200
    And the dossiers come from the most recent campaign or as an empty list

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Scenario 2: Unknown or inactive plot
  Scenario Outline: Unknown or inactive plot
    Given a GET request to "/api/v1/plots/<plotId>/agronomic-dossiers" sent by "<actor>" for an unknown or inactive plot
    When the API searches the plot
    Then the response status is 404

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |
