Feature: Member plot sector query (Cooperative)
  As a Client Application Developer
  I want to query the sector of a plot via GET to /api/v1/plot-sector-assignments/{plotId}
  so I can know the territorial location of the plot

  # Scenario 1: Successful query
  Scenario Outline: Successful query
    Given a GET request to "/api/v1/plot-sector-assignments/<plotId>" sent by "<actor>" for a plot reached by the user
    When the API reads its sector
    Then the response status is 200

    Examples:
      | plotId          | actor            |
      | plot-yarada-001 | usr-manager-0007 |

  # Scenario 2: Plot without sector or out of reach
  Scenario Outline: Plot without sector or out of reach
    Given a GET request to "/api/v1/plot-sector-assignments/<plotId>" sent by "<actor>" for a plot without sector or out of reach of the user
    When the API searches the sector
    Then the response status is 404

    Examples:
      | plotId          | actor            |
      | plot-yarada-001 | usr-manager-0007 |

  # Scenario 3: Request without authentication
  Scenario Outline: Request without authentication
    Given a GET request to "/api/v1/plot-sector-assignments/<plotId>" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | plotId          | actor            |
      | plot-yarada-001 | anonymous-client |

  # Scenario 4: User without an associated license
  Scenario Outline: User without an associated license
    Given a GET request to "/api/v1/plot-sector-assignments/<plotId>" sent by "<actor>" from a user who reaches no license
    When the API checks the access
    Then the response status is 403

    Examples:
      | plotId          | actor            |
      | plot-yarada-001 | usr-manager-0007 |
