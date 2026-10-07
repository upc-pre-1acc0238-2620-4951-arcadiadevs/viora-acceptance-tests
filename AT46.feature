Feature: Global agroclimatic incidents query with counters and filtering (Telemetry)
  As a Client Application Developer
  I want to query the general incident list via GET to /api/v1/agroclimatic-incidents with status and pagination filters
  so I can populate the mobile app alert center and display territorial severity counters

  # Escenario 1: Consulta paginada exitosa con contadores de severidad
  Scenario Outline: Paginated incident query with severity counters
    Given a GET request to "/api/v1/agroclimatic-incidents" with optional query parameters activeOnly, status, page and size
    When the API queries the telemetry context and evaluates frost, heatwave and water stress incidents
    Then the response status is 200
    And the response returns a paginated list of "AgroclimaticIncidentResponse" with consolidated severity counters

    Examples:
      | activeOnly | status | page | size | expectedCritical | expectedWarning |
      | true       | OPEN   | 0    | 10   | 1                | 2               |

  # Escenario 2: Parámetros de consulta con formato inválido
  Scenario Outline: Invalid query parameter format for incident query
    Given a GET request to "/api/v1/agroclimatic-incidents" with an unallowed status or negative pagination: "<status>", <page>
    When the transport layer validates query parameters
    Then the response status is 400

    Examples:
      | status  | page | reason              |
      | INVALID | 0    | unrecognized status |
      | OPEN    | -1   | negative page index |
