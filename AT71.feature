Feature: Assistant daily summary query (Assistant)
  As a Client Application Developer
  I want to request the daily summary of the field or of a plot via GET to /api/v1/assistant/daily-summary
  so I can show the priorities of the day

  # Escenario 1: Resumen diario del campo
  Scenario Outline: Field daily summary
    Given a GET request to "/api/v1/assistant/daily-summary?plotId=<plotId>" sent by "<actor>" without plot
    When the API retrieves or writes the summary of the day
    Then the response status is 200
    And the response returns the text and exactly three facts

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 2: Reutilización del resumen en el mismo día
  Scenario Outline: Summary reused on the same day
    Given a GET request to "/api/v1/assistant/daily-summary?plotId=<plotId>" sent by "<actor>" for a summary written today with the same figures and language
    When the producer requests it again
    Then the response status is 200
    And the existing summary is returned without consuming the quota

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 3: Productor sin parcelas activas
  Scenario Outline: Producer without active plots
    Given a GET request to "/api/v1/assistant/daily-summary?plotId=<plotId>" sent by "<actor>" from a producer without active plots
    When the API gathers the field figures
    Then the response status is 409

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 4: Límite de uso excedido
  Scenario Outline: Usage limit exceeded
    Given a GET request to "/api/v1/assistant/daily-summary?plotId=<plotId>" sent by "<actor>" when the summary must be written for a producer without quota
    When the API applies the usage limit
    Then the response status is 429
    And the response includes the Retry-After header

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 5: Identificador inválido
  Scenario Outline: Invalid identifier
    Given a GET request to "/api/v1/assistant/daily-summary?plotId=<plotId>" sent by "<actor>" with a malformed plot identifier
    When the API validates the parameter
    Then the response status is 400

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 6: Acceso denegado o parcela inexistente
  Scenario Outline: Access denied or unknown plot
    Given a GET request to "/api/v1/assistant/daily-summary?plotId=<plotId>" sent by "<actor>" for a foreign plot, a producer without an active plan or an unknown plot
    When the API checks the access
    Then the response status is 403
    And 403 applies to foreign plots or inactive plans and 404 to unknown plots

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |
