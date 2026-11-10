Feature: Plan extension query (Subscription)
  As a Client Application Developer
  I want to query an extension of a plan via GET to /api/v1/subscriptions/{subscriptionId}/extensions/{extensionId}
  so I can know its status

  # Escenario 1: Consulta exitosa
  Scenario Outline: Successful query
    Given a GET request to "/api/v1/subscriptions/<subscriptionId>/extensions/<extensionId>" sent by "<actor>" for an own extension
    When the API reads the extension
    Then the response status is 200
    And the response returns its detail

    Examples:
      | subscriptionId                       | extensionId                          | actor           |
      | 5d2e8f41-7c3b-4a96-8e1f-2b4c6d8e0a12 | 9a1b3c5d-7e9f-4b2d-8c4e-6f8a0b2c4d61 | usr-farmer-0042 |

  # Escenario 2: Ampliación no disponible
  Scenario Outline: Unavailable extension
    Given a GET request to "/api/v1/subscriptions/<subscriptionId>/extensions/<extensionId>" sent by "<actor>" for an extension that does not belong to the producer plan
    When the API searches the extension
    Then the response status is 404

    Examples:
      | subscriptionId                       | extensionId                          | actor           |
      | 5d2e8f41-7c3b-4a96-8e1f-2b4c6d8e0a12 | 9a1b3c5d-7e9f-4b2d-8c4e-6f8a0b2c4d61 | usr-farmer-0042 |
