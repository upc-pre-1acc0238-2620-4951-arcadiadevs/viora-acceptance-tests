Feature: Hectare extension code redemption (Subscription)
  As a Client Application Developer
  I want to redeem an extension code via POST to /api/v1/quota-extension-redemptions
  so I can add hectares to the sponsored plan of the producer

  # Escenario 1: Canje exitoso
  Scenario Outline: Successful redemption
    Given a POST request to "/api/v1/quota-extension-redemptions" sent by "<actor>" with a valid code
    When the API adds the hectares once per producer while the license has balance
    Then the response status is 201

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 2: Código no utilizable
  Scenario Outline: Code that cannot be used
    Given a POST request to "/api/v1/quota-extension-redemptions" sent by "<actor>" with a code that cannot be used
    When the API evaluates the code
    Then the response status is 400

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 3: Solicitud sin autenticación
  Scenario Outline: Request without authentication
    Given a POST request to "/api/v1/quota-extension-redemptions" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | actor            |
      | anonymous-client |

  # Escenario 4: Usuario sin rol de productor
  Scenario Outline: User without the producer role
    Given a POST request to "/api/v1/quota-extension-redemptions" sent by "<actor>" from a user who is not a producer
    When the API checks the role
    Then the response status is 403

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Escenario 5: Exceso de intentos fallidos
  Scenario Outline: Too many failed attempts
    Given a POST request to "/api/v1/quota-extension-redemptions" sent by "<actor>" after too many failed attempts
    When the API applies the attempt limit
    Then the response status is 429
    And the response includes the Retry-After header

    Examples:
      | actor           |
      | usr-farmer-0042 |
