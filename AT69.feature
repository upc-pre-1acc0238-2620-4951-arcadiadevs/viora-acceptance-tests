Feature: Latest answer of a context query (Assistant)
  As a Client Application Developer
  I want to request the latest answer of a screen and plot via GET to /api/v1/assistant/answers/latest
  so I can reopen the previous answer of the producer

  # Escenario 1: Recuperación de la última respuesta
  Scenario Outline: Latest answer recovery
    Given a GET request to "/api/v1/assistant/answers/latest?screen=<screen>&plotId=<plotId>" sent by "<actor>" for a context with an answer of the last ten days
    When the API finds the answer
    Then the response status is 200

    Examples:
      | screen      | plotId          | actor           |
      | ALTERNATION | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 2: Contexto sin respuesta previa
  Scenario Outline: Context without previous answer
    Given a GET request to "/api/v1/assistant/answers/latest?screen=<screen>&plotId=<plotId>" sent by "<actor>" for a context without valid answers
    When the API searches the answer
    Then the response status is 404

    Examples:
      | screen      | plotId          | actor           |
      | ALTERNATION | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 3: Parámetros inválidos o acceso denegado
  Scenario Outline: Invalid parameters or access denied
    Given a GET request to "/api/v1/assistant/answers/latest?screen=<screen>&plotId=<plotId>" sent by "<actor>" with invalid parameters, a foreign plot or an inactive plan
    When the API validates the request
    Then the response status is 400
    And 400 applies to invalid parameters and 403 to foreign plots or inactive plans

    Examples:
      | screen      | plotId          | actor           |
      | ALTERNATION | plot-yarada-001 | usr-farmer-0042 |
