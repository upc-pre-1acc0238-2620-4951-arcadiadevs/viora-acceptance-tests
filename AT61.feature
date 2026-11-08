Feature: Internal territorial agroclimatic and phytosanitary alerts query and subscription (Cooperative)
  As a Client Application Developer
  I want to request the cooperative internal agroclimatic and phenological alerts via GET to /api/v1/cooperatives/{cooperativeId}/territorial-alerts (with status and age filters)
  so I can display in the manager notification center the frost, water stress and fruit overload alerts of their sectors

  # Escenario 1: Listado de alertas territoriales activas y recientes
  Scenario Outline: Active and recent territorial alerts listing
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/territorial-alerts?status=<status>&normalizedSince=<normalizedSince>" authorized with a ROLE_TECHNICAL_MANAGER token
    When the API retrieves the risk events processed for member plots and valley agroclimatic stations
    Then the response status is 200
    And the response returns "TerritorialAlertListResource" with an array of alerts containing alertId, type (FROST_WARNING, CRITICAL_OVERLOAD, WATER_STRESS), sectorId, sectorName, severity, issue date and number of affected plots

    Examples:
      | cooperativeId      | status | normalizedSince      |
      | coop-valle-sama-01 | ACTIVE | 2026-11-01T00:00:00Z |

  # Escenario 2: Persistencia del aviso para el gestor independiente del estado silenciado del productor
  Scenario Outline: Alert persists for the manager regardless of farmer snooze state
    Given a "<alertType>" alert on member plot "<plotId>" whose farmer enabled the SNOOZE option in their mobile application
    When the technical manager queries "/api/v1/cooperatives/<cooperativeId>/territorial-alerts"
    Then the response status is 200
    And the response includes the active alert ensuring the member local preferences do not hide the risk status from technical supervision

    Examples:
      | cooperativeId      | plotId            | alertType         |
      | coop-valle-sama-01 | plot-jeronomo-001 | CRITICAL_OVERLOAD |

  # Escenario 3: Denegación de acceso para solicitantes ajenos a la organización
  Scenario Outline: Access denied to requesters outside the organization
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/territorial-alerts" issued by a user with role "<requesterRole>" without link to the cooperative
    When the requester identity is evaluated
    Then the response status is 403

    Examples:
      | cooperativeId      | requesterRole                     |
      | coop-valle-sama-01 | ROLE_PRODUCTOR                    |
      | coop-valle-sama-01 | ROLE_TECHNICAL_MANAGER_OTHER_COOP |
