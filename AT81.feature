Feature: Plan extension terms query (Subscription)
  As a Client Application Developer
  I want to query the extension terms of a plan via GET to /api/v1/subscriptions/{subscriptionId}/extension-terms
  so I can tell the producer how the plan can grow

  # Escenario 1: Consulta exitosa
  Scenario Outline: Successful query
    Given a GET request to "/api/v1/subscriptions/<subscriptionId>/extension-terms" sent by "<actor>" for an own plan
    When the API evaluates the plan
    Then the response status is 200
    And the response returns the extension terms

    Examples:
      | subscriptionId                       | actor           |
      | 5d2e8f41-7c3b-4a96-8e1f-2b4c6d8e0a12 | usr-farmer-0042 |

  # Escenario 2: Plan no disponible
  Scenario Outline: Unavailable plan
    Given a GET request to "/api/v1/subscriptions/<subscriptionId>/extension-terms" sent by "<actor>" for a plan that does not belong to the producer
    When the API searches the plan
    Then the response status is 404

    Examples:
      | subscriptionId                       | actor           |
      | 5d2e8f41-7c3b-4a96-8e1f-2b4c6d8e0a12 | usr-farmer-0042 |
