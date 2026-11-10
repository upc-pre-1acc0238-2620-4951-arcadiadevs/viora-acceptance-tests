Feature: Provisional agronomic dossier snapshot of an active campaign (Harvest)
  As a Client Application Developer
  I want to request the provisional dossier of a member plot via GET to /api/v1/member-plots/{id}/provisional-dossier
  so I can issue a preliminary document with a cut-off date and no premature seals

  # Scenario 1: Provisional technical snapshot metadata
  Scenario Outline: Provisional technical snapshot metadata
    Given a GET request to "/api/v1/member-plots/<id>/provisional-dossier" sent by "<actor>" with Accept application/json for a plot whose campaign is not settled
    When the API gathers the recorded evidence up to now
    Then the response status is 200
    And the response returns a PROVISIONAL document with its cut-off timestamp

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Scenario 2: Provisional PDF with cut-off mark
  Scenario Outline: Provisional PDF with cut-off mark
    Given a GET request to "/api/v1/member-plots/<id>/provisional-dossier" sent by "<actor>" with Accept application/pdf
    When the API renders the provisional document
    Then the PDF has no certification or final SHA-256 fingerprint

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Scenario 3: Unauthorized access
  Scenario Outline: Unauthorized access
    Given a GET request to "/api/v1/member-plots/<id>/provisional-dossier" sent by "<actor>" for a plot outside the cooperative portfolio
    When the API checks the access
    Then the response status is 403

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |
