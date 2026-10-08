Feature: Virtual sensor node registration and plot linking (Telemetry)
  As a Client Application Developer
  I want to register a virtual sensor node (microclimate or soil probe at 30/60 cm) via API
  so I can activate agroclimatic telemetry simulation for the plot

  # Escenario 1: Alta exitosa de nodo sensor virtual
  Scenario Outline: Successful virtual sensor node registration
    Given a POST request to "/api/v1/plots/<plotId>/iot-devices" with body containing "<name>", "<type>" and <depthCm>
    When the API validates valid sensor type and allowed depth for soil probes
    Then the response status is 201
    And the response returns "IotDeviceResource" with assigned id and status "ACTIVE"

    Examples:
      | plotId            | name               | type         | depthCm |
      | plot-jeronomo-001 | Weather Station 01 | MICROCLIMATE | 0       |
      | plot-jeronomo-001 | Soil Probe 30cm    | SOIL_PROBE   | 30      |

  # Escenario 2: Nombre duplicado de sensor en la misma parcela
  Scenario Outline: Duplicate sensor node name in the same plot
    Given a POST request with an already registered sensor name in said plot: "<name>"
    When the API checks name uniqueness within the plot
    Then the response status is 409

    Examples:
      | plotId            | name               |
      | plot-jeronomo-001 | Weather Station 01 |

  # Escenario 3: Parámetros de nodo inválidos
  Scenario Outline: Invalid sensor node parameters
    Given a POST request with unknown type or unallowed probe depth: "<type>", <depthCm>
    When the API evaluates technical configuration
    Then the response status is 400

    Examples:
      | plotId            | name        | type        | depthCm | reason              |
      | plot-jeronomo-001 | Bad Probe 1 | UNKNOWN     | 30      | invalid sensor type |
      | plot-jeronomo-001 | Bad Probe 2 | SOIL_PROBE  | 45      | depth must be 30/60 |
