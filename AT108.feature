Feature: Cooperative caliber ranges query and update (Cooperative)
  As a Client Application Developer
  I want to query and replace the caliber ranges of the organization via GET and PUT to /api/v1/caliber-ranges
  so I can configure the classification used by the intake projection

  # Scenario 1: Successful replacement of the caliber ranges
  Scenario Outline: Successful replacement of the caliber ranges
    Given a PUT request to "/api/v1/caliber-ranges" sent by "<actor>" with the ranges "<ranges>" ordered from the largest to the smallest fruit, consecutive, without overlaps or gaps and within 60 to 2000 fruits per kg
    When the API validates and stores the configuration of the license
    Then the response status is 200
    And the response returns the stored ranges and the intake projection is split with them

    Examples:
      | actor            | ranges                    |
      | usr-manager-0007 | 140-180, 181-220, 221-260 |

  # Scenario 2: Overlapping, inverted or out of scale ranges
  Scenario Outline: Overlapping, inverted or out of scale ranges
    Given a PUT request to "/api/v1/caliber-ranges" sent by "<actor>" with the ranges "<ranges>"
    When the API validates the list of ranges
    Then the response status is 400
    And the response returns reason "<reason>" and rangeIndex <rangeIndex>, keeping the current configuration

    Examples:
      | actor            | ranges           | reason                              | rangeIndex |
      | usr-manager-0007 | 180-140          | territory.caliber_range.inverted    | 0          |
      | usr-manager-0007 | 140-200, 180-260 | territory.caliber_range.overlapping | 1          |
      | usr-manager-0007 | 140-180, 200-260 | territory.caliber_range.gap         | 1          |
      | usr-manager-0007 | 40-100           | territory.caliber_range.off_scale   | 0          |

  # Scenario 3: Query of the configured ranges
  Scenario Outline: Query of the configured ranges
    Given a GET request to "/api/v1/caliber-ranges" sent by "<actor>" for an organization "<rangesState>"
    When the API reads the configuration of the license
    Then the response status is 200
    And the response returns <expected>

    Examples:
      | actor            | rangesState            | expected          |
      | usr-manager-0007 | with caliber ranges    | the stored ranges |
      | usr-manager-0007 | without caliber ranges | an empty list     |

  # Scenario 4: Unauthorized access
  Scenario Outline: Unauthorized access
    Given a "<method>" request to "/api/v1/caliber-ranges" sent by "<actor>" without the technical manager role
    When the API checks the role
    Then the response status is 403

    Examples:
      | method | actor           |
      | GET    | usr-farmer-0042 |
      | PUT    | usr-farmer-0042 |

  # Scenario 5: Configuration removal with an empty list
  Scenario Outline: Configuration removal with an empty list
    Given a PUT request to "/api/v1/caliber-ranges" sent by "<actor>" with an empty list of ranges
    When the API processes the configuration of the license
    Then the response status is 200
    And the stored ranges are removed and the intake projection is shown without caliber breakdown

    Examples:
      | actor            |
      | usr-manager-0007 |
