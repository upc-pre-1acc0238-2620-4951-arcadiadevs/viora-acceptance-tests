Feature: Plots by territorial sector and prioritized visit list query (Cooperative)
  As a Client Application Developer
  I want to query the plots belonging to a sector via GET to /api/v1/cooperatives/{cooperativeId}/sectors/{sectorId}/plots sorted by agronomic priority or GPS proximity
  so I can present the manager the ordered list of farms requiring urgent on-site assistance

  # Escenario 1: Consulta de parcelas ordenadas por prioridad de riesgo agronómico
  Scenario Outline: Plots sorted by agronomic risk priority
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/sectors/<sectorId>/plots?sort=priority&campaignYear=<campaignYear>"
    When the API filters member plots assigned to the sector label and sorts them hierarchically (critical by overload > 30% or frost first, moderate next, optimal last)
    Then the response status is 200
    And the response returns "SectorPlotsResource" with the prioritized plot list, plot identifier, member name, severity level and associated risk causes

    Examples:
      | cooperativeId      | sectorId       | campaignYear |
      | coop-valle-sama-01 | sector-sama-01 | 2026         |

  # Escenario 2: Ordenamiento por proximidad física del gestor con GPS
  Scenario Outline: Sorting by manager physical proximity with GPS
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/sectors/<sectorId>/plots?latitude=<latitude>&longitude=<longitude>&sort=distance"
    When the API computes the geodesic distance between the technician current point and each sector plot centroid
    Then the response status is 200
    And the response returns plots with the computed distanceKm property sorted from nearest to farthest

    Examples:
      | cooperativeId      | sectorId       | latitude | longitude |
      | coop-valle-sama-01 | sector-sama-01 | -17.9306 | -70.5112  |

  # Escenario 3: Sector territorial no encontrado
  Scenario Outline: Territorial sector not found
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/sectors/<sectorId>/plots" with a sectorId not present in the cooperative sector catalog
    When the service queries the territorial registry
    Then the response status is 404
    And the response follows RFC 7807

    Examples:
      | cooperativeId      | sectorId               |
      | coop-valle-sama-01 | sector-non-existent-99 |
