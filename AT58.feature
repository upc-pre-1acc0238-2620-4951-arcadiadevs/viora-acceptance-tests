Feature: Cooperative member farmer roster and member detail query (Membership)
  As a Client Application Developer
  I want to query the farmer member roster of a cooperative via GET to /api/v1/cooperatives/{cooperativeId}/members (with sector, name and status filters) and a member detail via GET to /api/v1/cooperatives/{cooperativeId}/members/{memberId}
  so I can display the farmer directory, their authorized contact data and their supervised plots

  # Escenario 1: Consulta paginada del directorio de socios vinculados
  Scenario Outline: Paginated query of the linked members directory
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/members" with optional parameters "?search=<search>&sectorId=<sectorId>&status=<status>&page=<page>&size=<size>"
    When the API validates the manager permissions and retrieves affiliated members under the authorized 1:N relationship
    Then the response status is 200
    And the response returns "PagedMemberListResource" with the farmer list, E.164 phone, email, number of plots, total declared surface and global counters of active and pending members

    Examples:
      | cooperativeId      | search | sectorId       | status  | page | size |
      | coop-valle-sama-01 |        |                |         | 0    | 20   |
      | coop-valle-sama-01 | Quispe | sector-sama-01 | ACTIVE  | 0    | 20   |
      | coop-valle-sama-01 |        |                | PENDING | 0    | 10   |

  # Escenario 2: Consulta detallada de la ficha de un socio productor
  Scenario Outline: Detailed farmer member record query
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/members/<memberId>" for a member belonging to the cooperative
    When the API compiles the farmer data and associated plots
    Then the response status is 200
    And the response returns "MemberDetailResource" with contact information, affiliation date and plot list with surface, olive variety and risk status

    Examples:
      | cooperativeId      | memberId        |
      | coop-valle-sama-01 | usr-farmer-0042 |

  # Escenario 3: Acceso denegado a datos de socios de otra organización
  Scenario Outline: Access denied to members of another organization
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/members/<memberId>" with a memberId not linked to the manager cooperative
    When the access policy evaluates the guild relationship
    Then the response status is 403
    And the farmers data remains confidential

    Examples:
      | cooperativeId      | memberId        |
      | coop-valle-sama-01 | usr-farmer-9001 |
