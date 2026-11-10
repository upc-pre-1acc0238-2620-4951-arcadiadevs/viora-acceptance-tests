Feature: Sector agroclimatic alerts query (Cooperative)
  As a Client Application Developer
  I want to list the alerts of the license sectors via GET to /api/v1/sector-alerts
  so I can show frost, water stress and overload alerts to the manager

  # Scenario 1: Active and recent territorial alerts list
  Scenario Outline: Active and recent territorial alerts list
    Given a GET request to "/api/v1/sector-alerts" sent by "<actor>" from a technical manager with a license in force
    When the API reads the alerts of the sectors
    Then the response status is 200
    And the response returns the type, sector, severity and affected plots

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Scenario 2: Alert kept for the manager regardless of the producer snooze
  Scenario Outline: Alert kept for the manager regardless of the producer snooze
    Given a GET request to "/api/v1/sector-alerts" sent by "<actor>" for an overload alert snoozed by the producer
    When the technical manager queries the sector alerts
    Then the alert stays visible for the manager

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Scenario 3: Access denied to users outside the organization
  Scenario Outline: Access denied to users outside the organization
    Given a GET request to "/api/v1/sector-alerts" sent by "<actor>" from a user without a link to the cooperative
    When the API checks the access
    Then the response status is 403

    Examples:
      | actor           |
      | usr-farmer-0042 |
