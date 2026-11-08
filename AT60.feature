Feature: Plot agronomic overview and technical record query in read-only supervision mode (Cooperative)
  As a Client Application Developer
  I want to query the agronomic overview of a member plot via GET to /api/v1/cooperatives/{cooperativeId}/plots/{plotId}/overview with campaignYear parameter
  so I can present the technical manager fruit load data, current prescription and phenology in strict read-only mode

  # Escenario 1: Consulta exitosa de ficha técnica de parcela supervisada
  Scenario Outline: Successful supervised plot technical record query
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/plots/<plotId>/overview?campaignYear=<campaignYear>" with a technical manager token
    When the API verifies the plot belongs to a linked member and compiles the current sampling, load and prescription models
    Then the response status is 200
    And the response returns "PlotAgronomicOverviewResource" with plot name, owner, variety, planting frame, fruit overload status, thinning prescription (suggested percentage and fruits per shoot), accumulated chill and risk level

    Examples:
      | cooperativeId      | plotId            | campaignYear |
      | coop-valle-sama-01 | plot-jeronomo-001 | 2026         |

  # Escenario 2: Parcela con registros agronómicos insuficientes
  Scenario Outline: Plot with insufficient agronomic records
    Given a member plot "<plotId>" that has not completed the fruit set sampling protocol in active campaign <campaignYear>
    When the API generates the technical overview
    Then the response status is 200
    And the response returns riskLevel "NO_DATA", null load and prescription values and the sampling progress status indicating pending observations without simulating data

    Examples:
      | cooperativeId      | plotId            | campaignYear |
      | coop-valle-sama-01 | plot-sin-muestreo | 2026         |

  # Escenario 3: Acceso no autorizado a parcela no vinculada a la cooperativa
  Scenario Outline: Unauthorized access to a plot not linked to the cooperative
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/plots/<plotId>/overview" on a plot whose owner has no link with the requesting cooperative
    When the institutional access policy validates the supervision relationship
    Then the response status is 403

    Examples:
      | cooperativeId      | plotId          |
      | coop-valle-sama-01 | plot-ajena-0777 |
