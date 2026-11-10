Feature: Final agronomic dossier query and export (Harvest)
  As a Client Application Developer
  I want to request the sealed dossier of a plot campaign with content negotiation via GET to /api/v1/plots/{plotId}/agronomic-dossiers/{campaignYear}
  so I can download the sealed dossier with its SHA-256 fingerprint

  # Scenario 1: Sealed dossier download as PDF
  Scenario Outline: Sealed dossier download as PDF
    Given a GET request to "/api/v1/plots/<plotId>/agronomic-dossiers/<campaignYear>" sent by "<actor>" with Accept application/pdf for a campaign with a sealed dossier
    When the API retrieves the sealed dossier
    Then the response status is 200
    And the response content type is application/pdf

    Examples:
      | plotId          | campaignYear | actor           |
      | plot-yarada-001 | 2026         | usr-farmer-0042 |

  # Scenario 2: Consolidated dossier and hash metadata of a closed campaign
  Scenario Outline: Consolidated dossier and hash metadata of a closed campaign
    Given a GET request to "/api/v1/plots/<plotId>/agronomic-dossiers/<campaignYear>" sent by "<actor>" with Accept application/json for a settled campaign
    When the API retrieves the sealed dossier
    Then the response status is 200
    And the response returns the yield summary, stabilization balance and SHA-256 fingerprint

    Examples:
      | plotId          | campaignYear | actor           |
      | plot-yarada-001 | 2026         | usr-farmer-0042 |

  # Scenario 3: Unauthorized access to another producer dossier
  Scenario Outline: Unauthorized access to another producer dossier
    Given a GET request to "/api/v1/plots/<plotId>/agronomic-dossiers/<campaignYear>" sent by "<actor>" for a plot the user does not own or supervise
    When the API checks the access
    Then the response status is 403

    Examples:
      | plotId          | campaignYear | actor           |
      | plot-yarada-001 | 2026         | usr-farmer-0042 |

  # Scenario 4: Campaign without sealed dossier
  Scenario Outline: Campaign without sealed dossier
    Given a GET request to "/api/v1/plots/<plotId>/agronomic-dossiers/<campaignYear>" sent by "<actor>" for a campaign without a sealed dossier
    When the API searches the dossier
    Then the response status is 404

    Examples:
      | plotId          | campaignYear | actor           |
      | plot-yarada-001 | 2026         | usr-farmer-0042 |
