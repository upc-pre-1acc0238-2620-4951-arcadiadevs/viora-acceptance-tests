Feature: Provisional agronomic dossier snapshot and metadata generation in active campaign (Harvest)
  As a Client Application Developer
  I want to request a dated snapshot of the agronomic dossier in an open campaign via GET to /api/v1/cooperatives/{cooperativeId}/plots/{plotId}/technical-dossier with parameter provisional=true
  so I can issue a preliminary document with observed facts and cut-off date without premature cryptographic seals

  # Escenario 1: Generación de metadatos de instantánea técnica provisional
  Scenario Outline: Provisional technical snapshot metadata generation
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/plots/<plotId>/technical-dossier?provisional=true" with header "Accept: application/json" on a plot whose current campaign <campaignYear> has not been settled
    When the documentation service compiles the recorded evidence (phenological data, recorded thinnings and weather series up to the query instant)
    Then the response status is 200
    And the response returns "ProvisionalDossierResource" with cutOffTimestamp, campaignYear, summary of performed interventions, explicit label documentType "PROVISIONAL" and fields without recorded data labeled "NOT_AVAILABLE"

    Examples:
      | cooperativeId      | plotId            | campaignYear |
      | coop-valle-sama-01 | plot-jeronomo-001 | 2026         |

  # Escenario 2: Solicitud de PDF provisional con marca de corte temporal
  Scenario Outline: Provisional PDF request with cut-off timestamp mark
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/plots/<plotId>/technical-dossier?provisional=true" with header "Accept: application/pdf"
    When the rendering engine processes the document template
    Then the response status is 200
    And the API delivers the PDF file with watermark and header "Expediente Provisional - Fecha de corte"
    And the document omits any external certification claim or final SHA-256 hash

    Examples:
      | cooperativeId      | plotId            |
      | coop-valle-sama-01 | plot-jeronomo-001 |

  # Escenario 3: Acceso no autorizado
  Scenario Outline: Unauthorized access
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/plots/<plotId>/technical-dossier?provisional=true" on a plot outside the cooperative portfolio
    When the security policy verifies access rights
    Then the response status is 403

    Examples:
      | cooperativeId      | plotId          |
      | coop-valle-sama-01 | plot-ajena-0777 |
