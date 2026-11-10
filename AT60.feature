Feature: Member plot agronomic overview query in read-only supervision mode (Cooperative)
  As a Client Application Developer
  I want to query a plot of a member who shares data via GET to /api/v1/member-plots/{id}
  so I can show the crop load, thinning prescription and phenology in read-only mode

  # Escenario 1: Consulta exitosa de ficha técnica de parcela supervisada
  Scenario Outline: Successful supervised plot record query
    Given a GET request to "/api/v1/member-plots/<id>" sent by "<actor>" for a plot of a member who shares data
    When the API reads the plot overview
    Then the response status is 200
    And the response returns the agronomic summary of the plot

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Escenario 2: Parcela con registros agronómicos insuficientes
  Scenario Outline: Plot with insufficient agronomic records
    Given a GET request to "/api/v1/member-plots/<id>" sent by "<actor>" for a plot without samplings or prescription
    When the API reads the plot overview
    Then the response status is 200
    And the missing data are marked as not available

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |

  # Escenario 3: Acceso no autorizado a parcela no vinculada a la cooperativa
  Scenario Outline: Unauthorized access to a plot outside the cooperative
    Given a GET request to "/api/v1/member-plots/<id>" sent by "<actor>" for a plot outside the members who share data
    When the API checks the access
    Then the response status is 403

    Examples:
      | id                                   | actor            |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-manager-0007 |
