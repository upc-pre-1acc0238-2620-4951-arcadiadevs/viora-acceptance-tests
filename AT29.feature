Feature: Territorial risk matrix and sector traffic light query with GPS positioning (Cooperative)
  As a Client Application Developer
  I want to request the consolidated territorial status of member plots via GET to /api/v1/cooperatives/{cooperativeId}/territorial-risk with optional geolocation parameters (latitude, longitude) and campaignYear
  so I can present the traffic light by highest observed severity and guide the manager in the field

  # Escenario 1: Consulta exitosa de matriz territorial con ubicación del gestor
  Scenario Outline: Successful territorial matrix query with manager location
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/territorial-risk?latitude=<latitude>&longitude=<longitude>&campaignYear=<campaignYear>" authorized with a ROLE_TECHNICAL_MANAGER token
    When the API locates the manager on the map and evaluates fruit overload (> 30%) and radiative frost risk (<= 1.5 °C) states in linked plots
    Then the response status is 200
    And the response returns "TerritorialRiskResource" with sectors with editable labels, member plot coordinates, the sector detected by GPS proximity and the consolidated traffic light by highest observed severity (critical, moderate, optimal and independent NO_DATA count)

    Examples:
      | cooperativeId      | latitude | longitude | campaignYear | expectedSector |
      | coop-valle-sama-01 | -17.9306 | -70.5112  | 2026         | sector-sama-01 |

  # Escenario 2: Consulta territorial global sin coordenadas GPS
  Scenario Outline: Global territorial query without GPS coordinates
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/territorial-risk?campaignYear=<campaignYear>" without latitude and longitude parameters issued by a manager with GPS disabled
    When the API processes the query for the organization
    Then the response status is 200
    And the response returns the general map and the macro traffic light of all sectors with locationStatus "GLOBAL"

    Examples:
      | cooperativeId      | campaignYear |
      | coop-valle-sama-01 | 2026         |

  # Escenario 3: Rechazo por falta de credenciales de gestor técnico
  Scenario Outline: Rejection due to missing technical manager credentials
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/territorial-risk" issued by a user with role "<requesterRole>" not belonging to the cooperative technical team
    When the requester authorization is evaluated
    Then the response status is 403

    Examples:
      | cooperativeId      | requesterRole                     |
      | coop-valle-sama-01 | ROLE_PRODUCTOR                    |
      | coop-valle-sama-01 | ROLE_TECHNICAL_MANAGER_OTHER_COOP |
