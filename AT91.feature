Feature: Plot field notes query (Orchard)
  As a Client Application Developer
  I want to list the notes of a plot via GET to /api/v1/plots/{plotId}/field-notes
  so I can review the observations recorded on the plot

  # Escenario 1: Listado de notas
  Scenario Outline: Notes list
    Given a GET request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" for an own plot
    When the API reads the notes
    Then the response status is 200
    And the notes come newest first or as an empty list

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 2: Parcela de otro productor
  Scenario Outline: Plot of another producer
    Given a GET request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" for a plot of another producer
    When the API checks the ownership
    Then the response status is 403

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 3: Parcela no encontrada
  Scenario Outline: Plot not found
    Given a GET request to "/api/v1/plots/<plotId>/field-notes" sent by "<actor>" for an unknown plot
    When the API searches the plot
    Then the response status is 404

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |
