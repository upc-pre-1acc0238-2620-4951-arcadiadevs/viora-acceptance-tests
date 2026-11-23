Feature: Field thinning execution confirmation and recording (Thinning)
  As a Client Application Developer
  I want to confirm the executed thinning of a prescription via POST to /api/v1/thinning-prescriptions/{id}/execution-confirmations
  so I can record the labor, update the load balance and project the caliber

  # Scenario 1: Successful confirmation with load balance and caliber projection
  Scenario Outline: Successful confirmation with load balance and caliber projection
    Given a POST request to "/api/v1/thinning-prescriptions/<id>/execution-confirmations" sent by "<actor>" with executed date, removal percentage, removed kilos, crew size and notes
    When the API records the execution
    Then the response status is 201
    And the response returns the load balance and caliber projection

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Scenario 2: Confirmation with full removal and caliber not applicable
  Scenario Outline: Confirmation with full removal and caliber not applicable
    Given a POST request to "/api/v1/thinning-prescriptions/<id>/execution-confirmations" sent by "<actor>" with a removal percentage equal to 100
    When the API records the execution
    Then the response status is 201
    And the residual load is zero and the caliber projection is NOT_APPLICABLE

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Scenario 3: Removal percentage out of range or invalid date
  Scenario Outline: Removal percentage out of range or invalid date
    Given a POST request to "/api/v1/thinning-prescriptions/<id>/execution-confirmations" sent by "<actor>" with a negative removal, above 100 or a future date
    When the API validates the request body
    Then the response status is 400

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Scenario 4: Unknown prescription
  Scenario Outline: Unknown prescription
    Given a POST request to "/api/v1/thinning-prescriptions/<id>/execution-confirmations" sent by "<actor>" for an unknown prescription identifier
    When the API searches the prescription
    Then the response status is 404

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
