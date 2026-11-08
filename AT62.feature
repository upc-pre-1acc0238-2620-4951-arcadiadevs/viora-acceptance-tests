Feature: Cooperative campaign history and annual production consolidation query (Cooperative)
  As a Client Application Developer
  I want to request the cooperative agricultural campaign catalog via GET to /api/v1/cooperatives/{cooperativeId}/campaigns
  so I can query the registered years, their status (OPEN/CLOSED), the bearing year classification (ON/OFF) and the consolidated historical intake balances

  # Escenario 1: Consulta del catálogo de campañas y comportamiento productivo histórico
  Scenario Outline: Campaign catalog and historical productive behavior query
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/campaigns" authorized with a technical manager token
    When the API retrieves the cooperative historical campaign series preserving the temporal scope of linked members in each period
    Then the response status is 200
    And the response returns "CooperativeCampaignListResource" with campaigns detailing campaignYear, status (OPEN or CLOSED), alternation classification (ON, OFF or UNKNOWN), total settled tons and number of computed plots

    Examples:
      | cooperativeId      | campaignYear | status | alternation | totalSettledTons |
      | coop-valle-sama-01 | 2026         | OPEN   | UNKNOWN     | 0.0              |
      | coop-valle-sama-01 | 2025         | CLOSED | ON          | 412.5            |
      | coop-valle-sama-01 | 2024         | CLOSED | OFF         | 198.3            |

  # Escenario 2: Respeto al principio de no reescritura histórica por afiliaciones recientes
  Scenario Outline: No historical rewriting due to recent affiliations
    Given a farmer "<memberId>" who joined the cooperative in the current year <currentYear>
    When the technical manager queries the intake consolidations of closed campaign <closedCampaignYear>
    Then the response status is 200
    And the response exposes the immutable historical figures <totalSettledTons> without retroactively recalculating past totals with the current member roster

    Examples:
      | cooperativeId      | memberId        | currentYear | closedCampaignYear | totalSettledTons |
      | coop-valle-sama-01 | usr-farmer-0150 | 2026        | 2025               | 412.5            |

  # Escenario 3: Acceso no autorizado para cuentas no gestoras
  Scenario Outline: Unauthorized access for non-manager accounts
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/campaigns" issued by a user with role "<requesterRole>" without institutional privileges in the entity
    When the API evaluates permissions
    Then the response status is 403

    Examples:
      | cooperativeId      | requesterRole  |
      | coop-valle-sama-01 | ROLE_PRODUCTOR |
