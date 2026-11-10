Feature: Extension payment preparation (Subscription)
  As a Client Application Developer
  I want to prepare or recover the payment of an extension with an Idempotency-Key header via POST to /api/v1/subscriptions/{subscriptionId}/extensions/{extensionId}/checkouts
  so I can complete the payment of a pending extension without duplicating it

  # Scenario 1: Payment preparation
  Scenario Outline: Payment preparation
    Given a POST request to "/api/v1/subscriptions/<subscriptionId>/extensions/<extensionId>/checkouts" sent by "<actor>" for a pending extension
    When the API prepares or recovers the payment
    Then the response status is 201
    And the response returns the data to complete it

    Examples:
      | subscriptionId                       | extensionId                          | actor           |
      | 5d2e8f41-7c3b-4a96-8e1f-2b4c6d8e0a12 | 9a1b3c5d-7e9f-4b2d-8c4e-6f8a0b2c4d61 | usr-farmer-0042 |

  # Scenario 2: Unavailable extension
  Scenario Outline: Unavailable extension
    Given a POST request to "/api/v1/subscriptions/<subscriptionId>/extensions/<extensionId>/checkouts" sent by "<actor>" for an extension that does not belong to the producer plan
    When the API searches the extension
    Then the response status is 404

    Examples:
      | subscriptionId                       | extensionId                          | actor           |
      | 5d2e8f41-7c3b-4a96-8e1f-2b4c6d8e0a12 | 9a1b3c5d-7e9f-4b2d-8c4e-6f8a0b2c4d61 | usr-farmer-0042 |
