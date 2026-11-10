Feature: Question catalog query by context (Assistant)
  As a Client Application Developer
  I want to request the assistant questions of a screen via GET to /api/v1/assistant/questions
  so I can show the closed questions available with the real figures

  # Scenario 1: Question catalog of a plot
  Scenario Outline: Question catalog of a plot
    Given a GET request to "/api/v1/assistant/questions?screen=<screen>&plotId=<plotId>" sent by "<actor>" with screen ALTERNATION for an own plot
    When the API evaluates the plot data
    Then the response status is 200
    And the response returns the questions in order with label, icon, enabled and disabledReason

    Examples:
      | screen      | plotId          | actor           |
      | ALTERNATION | plot-yarada-001 | usr-farmer-0042 |

  # Scenario 2: Catalog about the whole field
  Scenario Outline: Catalog about the whole field
    Given a GET request to "/api/v1/assistant/questions?screen=<screen>&plotId=<plotId>" sent by "<actor>" with screen HOME and no plot
    When the API processes the request
    Then the response status is 200
    And the questions refer to every active plot of the producer

    Examples:
      | screen      | plotId          | actor           |
      | ALTERNATION | plot-yarada-001 | usr-farmer-0042 |

  # Scenario 3: Invalid parameters
  Scenario Outline: Invalid parameters
    Given a GET request to "/api/v1/assistant/questions?screen=<screen>&plotId=<plotId>" sent by "<actor>" with an unknown screen or a malformed plot
    When the API validates the request
    Then the response status is 400

    Examples:
      | screen      | plotId          | actor           |
      | ALTERNATION | plot-yarada-001 | usr-farmer-0042 |

  # Scenario 4: Access denied or unknown plot
  Scenario Outline: Access denied or unknown plot
    Given a GET request to "/api/v1/assistant/questions?screen=<screen>&plotId=<plotId>" sent by "<actor>" for a foreign plot, a producer without an active plan or an unknown plot
    When the API checks the access
    Then the response status is 403
    And 403 applies to foreign plots or inactive plans and 404 to unknown plots

    Examples:
      | screen      | plotId          | actor           |
      | ALTERNATION | plot-yarada-001 | usr-farmer-0042 |
