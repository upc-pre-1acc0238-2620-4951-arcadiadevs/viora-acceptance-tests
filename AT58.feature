Feature: Cooperative member farmer roster query (Cooperative)
  As a Client Application Developer
  I want to list the members of the license via GET to /api/v1/cooperative-members
  so I can show the directory of farmers and their supervised plots

  # Scenario 1: Linked member directory query
  Scenario Outline: Linked member directory query
    Given a GET request to "/api/v1/cooperative-members" sent by "<actor>" from a technical manager with a license in force
    When the API reads the members of the license
    Then the response status is 200
    And the response returns the roster

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Scenario 2: Access denied to members of another organization
  Scenario Outline: Access denied to members of another organization
    Given a GET request to "/api/v1/cooperative-members" sent by "<actor>" from a user without a license in force
    When the API checks the access
    Then the response status is 403

    Examples:
      | actor            |
      | usr-manager-0007 |
