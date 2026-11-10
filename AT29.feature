Feature: Territorial risk matrix and sector traffic light query with GPS positioning (Cooperative)
  As a Client Application Developer
  I want to list the member plots with optional latitude and longitude via GET to /api/v1/member-plots
  so I can show the traffic light of each sector and guide the manager in the field

  # Scenario 1: Successful territorial matrix with manager location
  Scenario Outline: Successful territorial matrix with manager location
    Given a GET request to "/api/v1/member-plots?latitude=<latitude>&longitude=<longitude>" sent by "<actor>" with latitude and longitude of the manager
    When the API groups the member plots by sector and locates the manager
    Then the response status is 200
    And the response returns the sectors, plots and detected sector

    Examples:
      | latitude | longitude | actor            |
      | -18.0123 | -70.2456  | usr-manager-0007 |

  # Scenario 2: Global territorial query without GPS coordinates
  Scenario Outline: Global territorial query without GPS coordinates
    Given a GET request to "/api/v1/member-plots?latitude=<latitude>&longitude=<longitude>" sent by "<actor>" without coordinates
    When the API groups the member plots by sector
    Then the response status is 200
    And the response returns the general map of every sector

    Examples:
      | latitude | longitude | actor            |
      | -18.0123 | -70.2456  | usr-manager-0007 |

  # Scenario 3: Rejection without technical manager credentials
  Scenario Outline: Rejection without technical manager credentials
    Given a GET request to "/api/v1/member-plots?latitude=<latitude>&longitude=<longitude>" sent by "<actor>" from a user outside the cooperative technical team
    When the API checks the role
    Then the response status is 403

    Examples:
      | latitude | longitude | actor           |
      | -18.0123 | -70.2456  | usr-farmer-0042 |
