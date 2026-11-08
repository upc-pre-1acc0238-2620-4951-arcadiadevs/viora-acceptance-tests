Feature: Institutional license balance and corporate quota query (Membership)
  As a Client Application Developer
  I want to query the full corporate license balance via GET to /api/v1/cooperatives/{cooperativeId}/license
  so I can display the breakdown of contracted, reserved, occupied and available seats and hectares of the cooperative

  # Escenario 1: Consulta exitosa de capacidad y saldos de licencia institucional
  Scenario Outline: Successful institutional license capacity and balance query
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/license" with an authorized ROLE_TECHNICAL_MANAGER token
    When the API retrieves the cooperative active subscription and computes seat and hectare balances
    Then the response status is 200
    And the response returns "CooperativeLicenseResource" with licenseId, planName, totalSeats, occupiedSeats, reservedSeats, availableSeats, totalHectares, committedHectares, availableHectares, startDate and expiresAt

    Examples:
      | cooperativeId      | totalSeats | occupiedSeats | reservedSeats | availableSeats | totalHectares | committedHectares | availableHectares |
      | coop-valle-sama-01 | 100        | 48            | 10            | 42             | 500.0         | 290.0             | 210.0             |

  # Escenario 2: Cooperativa sin licencia activa configurada
  Scenario Outline: Cooperative without active license configured
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/license" for an entity without a current corporate contract in the system
    When the service looks up the license record
    Then the response status is 404
    And the response follows RFC 7807 indicating the absence of an active subscription

    Examples:
      | cooperativeId       |
      | coop-no-license-099 |

  # Escenario 3: Acceso denegado por falta de vinculación a la entidad
  Scenario Outline: Access denied due to missing entity membership
    Given a GET request to "/api/v1/cooperatives/<cooperativeId>/license" issued by a manager "<managerId>" belonging to another cooperative
    When the API verifies institutional membership
    Then the response status is 403

    Examples:
      | cooperativeId      | managerId    |
      | coop-valle-sama-01 | usr-mgr-0500 |
