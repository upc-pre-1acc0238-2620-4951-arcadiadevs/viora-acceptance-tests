Feature: Producer subscription query (Subscription)
  As a Client Application Developer
  I want to query a subscription via GET to /api/v1/subscriptions/{id}
  so I can retrieve the detail of an own plan

  # Escenario 1: Consulta exitosa
  Scenario Outline: Successful query
    Given a GET request to "/api/v1/subscriptions/<id>" sent by "<actor>" for an own subscription
    When the API reads the subscription
    Then the response status is 200
    And the response returns its detail

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Escenario 2: Suscripción no disponible
  Scenario Outline: Unavailable subscription
    Given a GET request to "/api/v1/subscriptions/<id>" sent by "<actor>" for a subscription that does not belong to the producer
    When the API searches the subscription
    Then the response status is 404

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
