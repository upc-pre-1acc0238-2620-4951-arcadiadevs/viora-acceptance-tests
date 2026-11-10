Feature: Thinning prescription query (Thinning)
  As a Client Application Developer
  I want to query a prescription via GET to /api/v1/thinning-prescriptions/{id}
  so I can retrieve it in any of its states

  # Scenario 1: Successful query
  Scenario Outline: Successful query
    Given a GET request to "/api/v1/thinning-prescriptions/<id>" sent by "<actor>" for an own prescription
    When the API reads the prescription
    Then the response status is 200

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Scenario 2: Invalid identifier
  Scenario Outline: Invalid identifier
    Given a GET request to "/api/v1/thinning-prescriptions/<id>" sent by "<actor>" with a malformed identifier
    When the API validates the parameter
    Then the response status is 400

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Scenario 3: Prescription of another producer
  Scenario Outline: Prescription of another producer
    Given a GET request to "/api/v1/thinning-prescriptions/<id>" sent by "<actor>" for a prescription of another producer
    When the API checks the ownership
    Then the response status is 403

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |

  # Scenario 4: Prescription not found
  Scenario Outline: Prescription not found
    Given a GET request to "/api/v1/thinning-prescriptions/<id>" sent by "<actor>" for an unknown prescription or one of an inactive plot
    When the API searches the prescription
    Then the response status is 404

    Examples:
      | id                                   | actor           |
      | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
