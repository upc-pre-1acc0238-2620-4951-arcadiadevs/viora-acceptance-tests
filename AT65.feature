Feature: Cooperative invitation code preview (Membership)
  As a Client Application Developer
  I want to preview what an invitation code offers via POST to /api/v1/cooperative-code-previews
  so I can show the conditions and the consent text before redeeming it

  # Escenario 1: Vista previa exitosa
  Scenario Outline: Successful preview
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" with a valid code
    When the API evaluates the code without consuming it
    Then the response status is 200
    And the response returns the organization, manager, quota, plan end and consent version

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 2: Código no utilizable
  Scenario Outline: Code that cannot be used
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" with an unknown, expired, redeemed or revoked code
    When the API evaluates the code
    Then the response status is 400

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 3: Productor con suscripción activa
  Scenario Outline: Producer with an active subscription
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" from a producer who already has an active subscription
    When the API checks the subscription
    Then the response status is 409

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 4: Solicitud sin autenticación
  Scenario Outline: Request without authentication
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | actor            |
      | anonymous-client |

  # Escenario 5: Usuario sin rol de productor
  Scenario Outline: User without the producer role
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" from a user who is not a producer
    When the API checks the role
    Then the response status is 403

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Escenario 6: Exceso de intentos fallidos
  Scenario Outline: Too many failed attempts
    Given a POST request to "/api/v1/cooperative-code-previews" sent by "<actor>" after too many failed attempts
    When the API applies the attempt limit
    Then the response status is 429
    And the response includes the Retry-After header

    Examples:
      | actor           |
      | usr-farmer-0042 |
