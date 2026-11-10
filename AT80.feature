Feature: Subscription payment preparation (Subscription)
  As a Client Application Developer
  I want to prepare or recover the payment with an Idempotency-Key header via POST to /api/v1/subscriptions/{id}/checkouts
  so I can let the producer complete the payment without duplicating it

  # Escenario 1: Preparación del pago
  Scenario Outline: Payment preparation
    Given a POST request to "/api/v1/subscriptions/<id>/checkouts" sent by "<actor>" for an own subscription pending payment
    When the API prepares or recovers the payment
    Then the response status is 201
    And the response returns the data to complete it

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Escenario 2: Suscripción no disponible
  Scenario Outline: Unavailable subscription
    Given a POST request to "/api/v1/subscriptions/<id>/checkouts" sent by "<actor>" for a subscription that does not belong to the producer
    When the API searches the subscription
    Then the response status is 404

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Escenario 3: Clave de idempotencia en conflicto
  Scenario Outline: Conflicting idempotency key
    Given a POST request to "/api/v1/subscriptions/<id>/checkouts" sent by "<actor>" with a key already used in an incompatible operation
    When the API evaluates the key
    Then the response status is 409

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
