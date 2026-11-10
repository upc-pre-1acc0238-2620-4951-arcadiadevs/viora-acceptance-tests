Feature: Paid individual plan extension request (Subscription)
  As a Client Application Developer
  I want to request an extension with added hectares and an Idempotency-Key header via POST to /api/v1/subscriptions/{subscriptionId}/extensions
  so I can add hectares to the individual plan

  # Escenario 1: Ampliación solicitada
  Scenario Outline: Extension requested
    Given a POST request to "/api/v1/subscriptions/<subscriptionId>/extensions" sent by "<actor>" with valid added hectares for an own plan
    When the API records the extension pending payment
    Then the response status is 201
    And the response returns the extension

    Examples:
      | subscriptionId                       | actor           |
      | 5d2e8f41-7c3b-4a96-8e1f-2b4c6d8e0a12 | usr-farmer-0042 |

  # Escenario 2: Reintento idempotente
  Scenario Outline: Idempotent retry
    Given a POST request to "/api/v1/subscriptions/<subscriptionId>/extensions" sent by "<actor>" that repeats a processed Idempotency-Key
    When the API identifies the key
    Then the response status is 200
    And the existing extension is returned

    Examples:
      | subscriptionId                       | actor           |
      | 5d2e8f41-7c3b-4a96-8e1f-2b4c6d8e0a12 | usr-farmer-0042 |

  # Escenario 3: Datos inválidos
  Scenario Outline: Invalid data
    Given a POST request to "/api/v1/subscriptions/<subscriptionId>/extensions" sent by "<actor>" with invalid hectares
    When the API validates the request
    Then the response status is 400

    Examples:
      | subscriptionId                       | actor           |
      | 5d2e8f41-7c3b-4a96-8e1f-2b4c6d8e0a12 | usr-farmer-0042 |

  # Escenario 4: Operación en conflicto
  Scenario Outline: Conflicting operation
    Given a POST request to "/api/v1/subscriptions/<subscriptionId>/extensions" sent by "<actor>" for an extension incompatible with the current plan state
    When the API evaluates the request
    Then the response status is 409

    Examples:
      | subscriptionId                       | actor           |
      | 5d2e8f41-7c3b-4a96-8e1f-2b4c6d8e0a12 | usr-farmer-0042 |
