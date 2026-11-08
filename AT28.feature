Feature: Provisional and final agronomic dossier generation and export in PDF and JSON (Harvest)
  As a Client Application Developer
  I want to request the agronomic dossier of a plot via GET to /api/v1/cooperatives/{cooperativeId}/plots/{plotId}/technical-dossier (or /api/v1/plots/{plotId}/agronomic-dossier) with content negotiation (Accept: application/pdf or application/json) and campaignYear parameter
  so I can download the provisional technical document in an active campaign or the dossier sealed with SHA-256 hash in a closed campaign

  # Escenario 1: Descarga de expediente binario PDF en campaña activa como instantánea provisional
  Scenario Outline: Binary PDF dossier download in active campaign as provisional snapshot
    Given a GET request to "<endpoint>?campaignYear=<campaignYear>" with header "Accept: application/pdf", an ongoing campaign and an authorized token
    When the engine compiles available flowering, fruit set, telemetry and thinning data recorded up to the cut-off date
    Then the response status is 200
    And the response has "Content-Type: application/pdf" and a "Content-Disposition" header for download
    And the document is visibly labeled "Expediente Agronómico Provisional" marking fields without data as not available and without cryptographic seals

    Examples:
      | endpoint                                                                          | campaignYear |
      | /api/v1/cooperatives/coop-valle-sama-01/plots/plot-jeronomo-001/technical-dossier | 2026         |
      | /api/v1/plots/plot-jeronomo-001/agronomic-dossier                                 | 2026         |

  # Escenario 2: Consulta de expediente consolidado y metadatos con hash en campaña cerrada
  Scenario Outline: Consolidated dossier and hash metadata query in closed campaign
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/plots/<plotId>/technical-dossier?campaignYear=<campaignYear>" with header "Accept: application/json" for a concluded and formally settled campaign
    When the API retrieves the final sealed dossier aggregate
    Then the response status is 200
    And the response returns "TechnicalDossierResource" with yield summary, stabilization balance and SHA-256 document integrity fingerprint

    Examples:
      | cooperativeId      | plotId            | campaignYear |
      | coop-valle-sama-01 | plot-jeronomo-001 | 2025         |

  # Escenario 3: Acceso no autorizado a expediente de parcela ajena
  Scenario Outline: Unauthorized access to another owner's plot dossier
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/plots/<plotId>/technical-dossier" issued by a user with role "<requesterRole>" without technical supervision permissions or ownership of the plot
    When the institutional access policy evaluates the plot membership
    Then the response status is 403
    And the farmer agronomic data remains protected

    Examples:
      | cooperativeId      | plotId            | requesterRole  |
      | coop-valle-sama-01 | plot-jeronomo-001 | ROLE_PRODUCTOR |
