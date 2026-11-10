Feature: Agronomic dossier sealing of a settled campaign (Harvest)
  As a Client Application Developer
  I want to seal the dossier of a campaign via POST to /api/v1/plots/{plotId}/agronomic-dossiers
  so I can keep a final and verifiable document of the campaign

  # Escenario 1: Expediente sellado
  Scenario Outline: Dossier sealed
    Given a POST request to "/api/v1/plots/<plotId>/agronomic-dossiers" sent by "<actor>" for a settled campaign of an own plot
    When the API gathers the campaign data, renders the document and stores its SHA-256 fingerprint
    Then the response status is 201

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 2: Expediente ya sellado
  Scenario Outline: Dossier already sealed
    Given a POST request to "/api/v1/plots/<plotId>/agronomic-dossiers" sent by "<actor>" for a campaign that already has a dossier
    When the seal is requested again
    Then the response status is 200
    And the existing dossier is returned

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 3: Parcela o campaña inválida
  Scenario Outline: Invalid plot or campaign
    Given a POST request to "/api/v1/plots/<plotId>/agronomic-dossiers" sent by "<actor>" with an invalid plot identifier or campaign
    When the API validates the request
    Then the response status is 400

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 4: Parcela de otro productor
  Scenario Outline: Plot of another producer
    Given a POST request to "/api/v1/plots/<plotId>/agronomic-dossiers" sent by "<actor>" for a plot of another producer
    When the API checks the ownership
    Then the response status is 403

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 5: Parcela inexistente o inactiva
  Scenario Outline: Unknown or inactive plot
    Given a POST request to "/api/v1/plots/<plotId>/agronomic-dossiers" sent by "<actor>" for an unknown or inactive plot
    When the API searches the plot
    Then the response status is 404

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |

  # Escenario 6: Campaña sin liquidar
  Scenario Outline: Unsettled campaign
    Given a POST request to "/api/v1/plots/<plotId>/agronomic-dossiers" sent by "<actor>" for a campaign that has not been settled
    When the API evaluates the campaign
    Then the response status is 422

    Examples:
      | plotId          | actor           |
      | plot-yarada-001 | usr-farmer-0042 |
