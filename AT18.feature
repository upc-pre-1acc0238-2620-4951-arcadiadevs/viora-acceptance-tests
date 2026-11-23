Feature: Virtual node decommissioning preserving historical traceability (Telemetry)
  As a Client Application Developer
  I want to request the decoupling of a virtual node from the API
  so I can retire obsolete sensors while preserving historical readings associated with the plot

  # Scenario 1: Successful virtual node decommissioning
  Scenario Outline: Successful virtual node decommissioning
    Given a DELETE request to "/api/v1/plots/<plotId>/iot-devices/<deviceId>" issued by the plot owner
    When the API verifies ownership and executes logical retirement of the node
    Then the response status is 200
    And the integrity of previous time-series readings is maintained

    Examples:
      | plotId            | deviceId         |
      | plot-jeronomo-001 | dev-probe-soil-1 |

  # Scenario 2: Device not found for decommissioning
  Scenario Outline: Device not found for decommissioning
    Given a DELETE request with a non-existent device identifier: "<deviceId>"
    When the API searches the device registry
    Then the response status is 404

    Examples:
      | plotId            | deviceId             |
      | plot-jeronomo-001 | dev-non-existent-999 |

  # Scenario 3: Outdated device revision
  Scenario Outline: Outdated device revision
    Given a DELETE request to "/api/v1/plots/<plotId>/iot-devices/<id>" sent by "<actor>" with an If-Match header that does not match the current device version
    When the API compares the revision
    Then the response status is 412

    Examples:
      | plotId          | id                                   | actor           |
      | plot-yarada-001 | 3f6b2c1e-9a4d-4e8b-b1c2-7d5e6f8a9b01 | usr-farmer-0042 |
