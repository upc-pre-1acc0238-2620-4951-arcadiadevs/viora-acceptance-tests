Feature: Global plot sampling overview query for plot picker (Thinning)
  As a Client Application Developer
  I want to query consolidated sampling status of all plots via GET to /api/v1/samplings/overview
  so I can render the Plot Picker in the mobile interface highlighting progress and sufficiency

  # Escenario 1: Consulta exitosa de cobertura y estado de muestreo de los cuarteles
  Scenario Outline: Successful sampling coverage query for plot picker
    Given a GET request to "/api/v1/samplings/overview" with optional parameters campaignYear and status
    When the API consolidates active producer plots and computes sampling progress and statistical sufficiency
    Then the response status is 200
    And the response returns a list of "PlotSamplingOverviewResponse" optimized for the Plot Picker

    Examples:
      | campaignYear | status | expectedPlotCount |
      | 2025         | ACTIVE | 3                 |

  # Escenario 2: Formato inválido en año de campaña o filtro de estado
  Scenario Outline: Invalid format in campaign year or status filter
    Given a GET request to "/api/v1/samplings/overview" with campaign year below 2000 or unknown status: <campaignYear>, "<status>"
    When the controller processes query parameters
    Then the response status is 400

    Examples:
      | campaignYear | status  | reason             |
      | 1995         | ACTIVE  | year below 2000    |
      | 2025         | UNKNOWN | unrecognized status|
