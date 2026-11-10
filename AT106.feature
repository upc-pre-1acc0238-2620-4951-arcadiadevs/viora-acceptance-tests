Feature: Recorded thinning execution query (Thinning)
  As a Client Application Developer
  I want to query the recorded execution of a prescription via GET to /api/v1/thinning-prescriptions/{id}/execution-confirmations
  so I can review its load balance, caliber projection and yield

  # Escenario 1: Consulta exitosa
  Scenario Outline: Successful query
    Given a GET request to "/api/v1/thinning-prescriptions/<id>/execution-confirmations" sent by "<actor>" for a recorded labor
    When the API reads the execution
    Then the response status is 200
    And the response returns the load balance, caliber projection and yield

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Escenario 2: Identificador inválido
  Scenario Outline: Invalid identifier
    Given a GET request to "/api/v1/thinning-prescriptions/<id>/execution-confirmations" sent by "<actor>" with a malformed identifier
    When the API validates the parameter
    Then the response status is 400

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Escenario 3: Ejecución no disponible
  Scenario Outline: Execution not available
    Given a GET request to "/api/v1/thinning-prescriptions/<id>/execution-confirmations" sent by "<actor>" for an unknown prescription or one without recorded labor
    When the API searches the execution
    Then the response status is 404

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
