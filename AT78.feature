Feature: Current producer subscription query (Subscription)
  As a Client Application Developer
  I want to query the current subscription via GET to /api/v1/subscriptions
  so I can know the status of the plan of the authenticated producer

  # Escenario 1: Productor con suscripción
  Scenario Outline: Producer with a subscription
    Given a GET request to "/api/v1/subscriptions" sent by "<actor>" from a producer with a subscription in force
    When the API reads the subscription
    Then the response status is 200
    And the response returns its detail

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 2: Productor sin suscripción
  Scenario Outline: Producer without a subscription
    Given a GET request to "/api/v1/subscriptions" sent by "<actor>" from a producer without a current subscription
    When the API reads the subscription
    Then the response status is 204

    Examples:
      | actor           |
      | usr-farmer-0042 |
