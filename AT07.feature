Feature: Payment notification webhook reception and processing (Subscription)
  As a Client Application Developer
  I want to receive the payment notifications of Mercado Pago via POST to /api/v1/payment-notifications/mercado-pago
  so I can activate the producer subscription as soon as the payment is approved

  # Scenario 1: Successful processing of an approved payment
  Scenario Outline: Successful processing of an approved payment
    Given a POST request to "/api/v1/payment-notifications/mercado-pago" sent by "<actor>" with a valid signature and an approved payment
    When the API authenticates the notification and reconciles the payment
    Then the response status is 200
    And the subscription becomes ACTIVE with its validity date

    Examples:
      | actor                |
      | mercado-pago-webhook |

  # Scenario 2: Invalid webhook signature
  Scenario Outline: Invalid webhook signature
    Given a POST request to "/api/v1/payment-notifications/mercado-pago" sent by "<actor>" with a missing or altered signature
    When the API authenticates the notification
    Then the response status is 400
    And the notification is discarded

    Examples:
      | actor                |
      | mercado-pago-webhook |
