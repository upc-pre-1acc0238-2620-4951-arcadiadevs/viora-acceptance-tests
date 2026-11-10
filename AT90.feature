Feature: Plot field note recording (Orchard)
  As a Client Application Developer
  I want to record a note with id, type, text and observation date via POST to /api/v1/plots/{plotId}/field-notes
  so I can keep the producer observations without duplicating them on retries

  # Escenario 1: Nota registrada
  Scenario Outline: Note recorded
    Given a POST request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" with a valid note for an own active plot
    When the API stores the note
    Then the response status is 201

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 2: Reintento de la misma nota
  Scenario Outline: Retry of the same note
    Given a POST request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" with a note already stored
    When the API identifies the note
    Then the response status is 200
    And the stored note is returned

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 3: Datos inválidos
  Scenario Outline: Invalid data
    Given a POST request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" with an invalid id, type or text or a future date
    When the API validates the note
    Then the response status is 400

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 4: Identificador en uso
  Scenario Outline: Identifier in use
    Given a POST request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" with an id used by another note
    When the API validates the identifier
    Then the response status is 409

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 5: Parcela de otro productor
  Scenario Outline: Plot of another producer
    Given a POST request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" for a plot of another producer
    When the API checks the ownership
    Then the response status is 403

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 6: Parcela inexistente o inactiva
  Scenario Outline: Unknown or inactive plot
    Given a POST request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" for an unknown or inactive plot
    When the API searches the plot
    Then the response status is 404

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |
