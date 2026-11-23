Feature: Checkout preference generation for independent producer subscription (Subscription)
  As a Client Application Developer
  I want to create an individual subscription pending payment via POST to /api/v1/subscriptions
  so I can obtain the checkout data of the payment gateway

  # Scenario 1: Successful subscription preference creation
  Scenario Outline: Successful subscription preference creation
    Given a POST request to "/api/v1/subscriptions" sent by "<actor>" with the producer plan and a positive number of hectares
    When the API creates the subscription pending payment
    Then the response status is 201
    And the response returns the checkout preference data

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Scenario 2: Invalid subscription data
  Scenario Outline: Invalid subscription data
    Given a POST request to "/api/v1/subscriptions" sent by "<actor>" with zero hectares or an unknown plan
    When the API validates the request body
    Then the response status is 400
    And the response describes the error

    Examples:
      | actor           |
      | usr-farmer-0042 |
