Feature: Individual subscription plans query (Subscription)
  As a Client Application Developer
  I want to list the individual plans via GET to /api/v1/subscription-plans
  so I can show the producer the available subscription options

  # Scenario 1: Plans list
  Scenario Outline: Plans list
    Given a GET request to "/api/v1/subscription-plans" sent by "<actor>" from any client
    When the API reads the individual plan catalog
    Then the response status is 200
    And the response returns the available plans

    Examples:
      | actor           |
      | usr-farmer-0042 |
