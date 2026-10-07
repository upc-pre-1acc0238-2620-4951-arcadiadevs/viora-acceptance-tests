Feature: Inventory query of virtual sensor nodes linked to plot (Telemetry)
  As a Client Application Developer
  I want to request the listing of virtual nodes linked to a plot from the API
  so I can display their operational status and latest simulated telemetry reading in the UI

  # Escenario 1: Listado de dispositivos vinculados
  Scenario Outline: Listing linked virtual IoT devices
    Given a GET request to "/api/v1/plots/<plotId>/iot-devices" with an authorized user token
    When the API retrieves devices associated with the plot
    Then the response status is 200
    And the response returns an array of "IotDeviceResource" objects detailing id, name, type, depthCm, status and lastReadingTimestamp

    Examples:
      | plotId            | expectedDeviceCount |
      | plot-jeronomo-001 | 2                   |

  # Escenario 2: Parcela inexistente
  Scenario Outline: Plot not found for IoT device inventory query
    Given a GET request with a non-existent plotId: "<plotId>"
    When the API queries the persistence layer
    Then the response status is 404

    Examples:
      | plotId                |
      | plot-non-existent-999 |
