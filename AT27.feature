Feature: Field thinning execution confirmation and recording (Thinning)
  As a Client Application Developer
  I want to confirm the executed thinning of a prescription via POST to /api/v1/thinning-prescriptions/{id}/execution-confirmations
  so I can record the labor, update the load balance and project the caliber

  # Escenario 1: Confirmación exitosa con balance de carga y proyección de calibre COI (HTTP 201 Created)
  Scenario Outline: Successful confirmation with load balance and caliber projection
    Given a POST request to "/api/v1/thinning-prescriptions/<id>/execution-confirmations" sent by "<actor>" with executed date, removal percentage, removed kilos, crew size and notes
    When the API records the execution
    Then the response status is 201
    And the response returns the load balance and caliber projection

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Escenario 2: Confirmación con 100 % de remoción y calibre no aplicable (HTTP 201 Created)
  Scenario Outline: Confirmation with full removal and caliber not applicable
    Given a POST request to "/api/v1/thinning-prescriptions/<id>/execution-confirmations" sent by "<actor>" with a removal percentage equal to 100
    When the API records the execution
    Then the response status is 201
    And the residual load is zero and the caliber projection is NOT_APPLICABLE

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Escenario 3: Porcentaje de remoción fuera de rango o fecha inválida (HTTP 400 Bad Request)
  Scenario Outline: Removal percentage out of range or invalid date
    Given a POST request to "/api/v1/thinning-prescriptions/<id>/execution-confirmations" sent by "<actor>" with a negative removal, above 100 or a future date
    When the API validates the request body
    Then the response status is 400

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Escenario 4: Cuartel o prescripción activa inexistente (HTTP 404 Not Found)
  Scenario Outline: Unknown prescription
    Given a POST request to "/api/v1/thinning-prescriptions/<id>/execution-confirmations" sent by "<actor>" for an unknown prescription identifier
    When the API searches the prescription
    Then the response status is 404

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
