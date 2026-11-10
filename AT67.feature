Feature: Idempotent assistant answer request (Assistant)
  As a Client Application Developer
  I want to ask a question of the catalog via POST to /api/v1/assistant/answers
  so I can obtain an answer validated against the real data without duplicating it on retries

  # Escenario 1: Generación exitosa de respuesta
  Scenario Outline: Successful answer generation
    Given a POST request to "/api/v1/assistant/answers" sent by "<actor>" with questionId, plotId, clientRequestId and forceRefresh
    When the API reads the plot data and writes the answer
    Then the response status is 200
    And the response returns the text, exactly two facts, sources, actions, freshness and model

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 2: Reintento con la misma clave de idempotencia
  Scenario Outline: Retry with the same idempotency key
    Given a POST request to "/api/v1/assistant/answers" sent by "<actor>" that repeats a processed clientRequestId
    When the API identifies the key
    Then the response status is 200
    And the same stored answer is returned

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 3: Pregunta sin datos suficientes
  Scenario Outline: Question without enough data
    Given a POST request to "/api/v1/assistant/answers" sent by "<actor>" for a question that cannot be answered with the recorded data
    When the API evaluates its availability
    Then the response status is 409
    And no value is estimated

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 4: Texto generado rechazado o no disponible
  Scenario Outline: Rejected or unavailable generated text
    Given a POST request to "/api/v1/assistant/answers" sent by "<actor>" when the generated text has unbacked figures or the writer is unavailable
    When the API validates the result
    Then the response status is 200
    And the template text is returned with model fallback true

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 5: Límite de uso excedido
  Scenario Outline: Usage limit exceeded
    Given a POST request to "/api/v1/assistant/answers" sent by "<actor>" after 20 new answers or 5 forced refreshes in 60 minutes
    When the API applies the usage limit
    Then the response status is 429
    And the response includes the Retry-After header

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 6: Solicitud inválida
  Scenario Outline: Invalid request
    Given a POST request to "/api/v1/assistant/answers" sent by "<actor>" with an unknown question or a malformed identifier
    When the API validates the request
    Then the response status is 400

    Examples:
      | actor           |
      | usr-farmer-0042 |

  # Escenario 7: Acceso denegado o parcela inexistente
  Scenario Outline: Access denied or unknown plot
    Given a POST request to "/api/v1/assistant/answers" sent by "<actor>" for a foreign plot, a producer without an active plan or an unknown plot
    When the API checks the access
    Then the response status is 403
    And 403 applies to foreign plots or inactive plans and 404 to unknown plots

    Examples:
      | actor           |
      | usr-farmer-0042 |
