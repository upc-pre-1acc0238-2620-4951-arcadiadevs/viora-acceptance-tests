Feature: Relational persistence conventions ORM naming and spatial typing (Shared)
  As a Core Platform Engineer
  I want to configure the object-relational mapping strategy in the ORM
  so I can standardize automatic camelCase to snake_case column mapping and persist WGS84 spatial geometries consistently

  # Escenario 1: Mapeo automático de entidades y convenciones
  Scenario Outline: Automatic entity and naming convention mapping
    Given the persistence layer interacting with the relational database
    When ORM migrations and schema mappings are analyzed for "<entityName>"
    Then the table is mapped to lowercase plural "<tableName>" and columns use snake_case
    And foreign keys preserve referential integrity constraints

    Examples:
      | entityName  | tableName            | sampleColumnMapping          |
      | Plot        | plots                | planting_year, row_spacing_m |
      | SensorNode  | virtual_sensor_nodes | sensor_type, depth_cm        |

  # Escenario 2: Conversión bidireccional de geometrías espaciales
  Scenario Outline: Bidirectional spatial geometry conversion
    Given domain entities with boundary coordinates: "<geometryType>"
    When they are persisted or retrieved from the PostgreSQL engine
    Then the ORM transparently serializes and deserializes between native spatial types and GeoJSON WGS84

    Examples:
      | geometryType | formatStandard |
      | Polygon      | GeoJSON WGS84  |
