Feature: Soil-climatic offset calibration and adjustment for plot IoT sensor node (Telemetry)
  As a Client Application Developer
  I want to send calibration parameters via PUT to /api/v1/plots/{plotId}/iot-devices/{deviceId} with If-Match header
  so I can adjust telemetry readings to plot edafoclimatic conditions while preventing concurrency discrepancies

  # Escenario 1: Calibración exitosa de sonda IoT con concurrencia optimista
  Scenario Outline: Successful IoT sensor probe calibration
    Given a PUT request to "/api/v1/plots/<plotId>/iot-devices/<deviceId>" with If-Match header "<ifMatch>" and body containing <multiplier>, <tempOffset>, <humOffset> and <soilFactor>
    When the API validates ownership, verifies version ETag, confirms device is active and persists calibration coefficients
    Then the response status is 200
    And the response returns updated "IoTDeviceResponse" and emits an updated "ETag" header

    Examples:
      | plotId            | deviceId         | ifMatch | multiplier | tempOffset | humOffset | soilFactor |
      | plot-jeronomo-001 | dev-probe-soil-1 | "\"1\"" | 1.05       | -0.5       | 1.2       | 1.10       |

  # Escenario 2: Parámetros de calibración fuera de rangos admisibles
  Scenario Outline: Calibration parameters out of permissible physical ranges
    Given a PUT request with non-positive multiplier or offset values exceeding physical probe limits: <multiplier>, <tempOffset>
    When the domain validator processes the payload
    Then the response status is 400
    And the response indicates physical measurement restrictions violated

    Examples:
      | plotId            | deviceId         | multiplier | tempOffset | reason                        |
      | plot-jeronomo-001 | dev-probe-soil-1 | -0.1       | 0.0        | multiplier must be positive   |
      | plot-jeronomo-001 | dev-probe-soil-1 | 1.0        | 45.0       | offset exceeds probe bounds   |

  # Escenario 3: Dispositivo o cuartel no encontrado
  Scenario Outline: Device or plot not found for calibration
    Given a PUT request with non-existent plotId or deviceId: "<plotId>", "<deviceId>"
    When the API searches the device catalog
    Then the response status is 404

    Examples:
      | plotId                | deviceId             |
      | plot-non-existent-999 | dev-probe-soil-1     |
      | plot-jeronomo-001     | dev-non-existent-999 |

  # Escenario 4: Conflicto de versión por concurrencia optimista
  Scenario Outline: Version conflict due to optimistic concurrency during calibration
    Given a PUT request where If-Match header "<ifMatch>" does not match current version
    When the concurrency interceptor detects simultaneous prior modification
    Then the response status is 412
    And the response indicates precondition failed under RFC 7807

    Examples:
      | plotId            | deviceId         | ifMatch |
      | plot-jeronomo-001 | dev-probe-soil-1 | "\"0\"" |
