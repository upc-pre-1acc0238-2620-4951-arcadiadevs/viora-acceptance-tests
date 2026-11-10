Feature: Territorial sector registration (Cooperative)
  As a Client Application Developer
  I want to add a sector with a name via POST to /api/v1/sector-zones
  so I can extend the list of sectors of the license

  # Scenario 1: Sector added
  Scenario Outline: Sector added
    Given a POST request to "/api/v1/sector-zones" sent by "<actor>" from a technical manager with a license in force
    When the API records the sector
    Then the response status is 201

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Scenario 2: Invalid name
  Scenario Outline: Invalid name
    Given a POST request to "/api/v1/sector-zones" sent by "<actor>" with a blank, too short or too long name
    When the API validates the name
    Then the response status is 400

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Scenario 3: Repeated name
  Scenario Outline: Repeated name
    Given a POST request to "/api/v1/sector-zones" sent by "<actor>" with a name already in the list regardless of accents or case
    When the API validates its uniqueness
    Then the response status is 409

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Scenario 4: Request without authentication
  Scenario Outline: Request without authentication
    Given a POST request to "/api/v1/sector-zones" sent by "<actor>" without a valid access token
    When the API checks the identity
    Then the response status is 401

    Examples:
      | actor            |
      | anonymous-client |

  # Scenario 5: Manager without a license in force
  Scenario Outline: Manager without a license in force
    Given a POST request to "/api/v1/sector-zones" sent by "<actor>" from a user who is not a manager with a license in force
    When the API checks the access
    Then the response status is 403

    Examples:
      | actor           |
      | usr-farmer-0042 |
