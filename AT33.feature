Feature: Dynamic API contract generation and OpenAPI interactive documentation (Shared)
  As a Core Platform Engineer
  I want to integrate the OpenAPI 3.0 contract generator in the backend
  so I can expose an interactive Swagger UI console and JSON schemas documenting all system endpoints

  # Escenario 1: Exposición de consola Swagger UI
  Scenario Outline: Swagger UI interactive console exposure
    Given the backend platform running in "<environment>"
    When a developer accesses "<swaggerPath>"
    Then the system displays live interactive documentation with all REST controllers and Bearer JWT auth

    Examples:
      | environment | swaggerPath       | expectedTitle           |
      | local       | /swagger-ui.html  | Viora Agronomic Platform |

  # Escenario 2: Generación del esquema OpenAPI en formato JSON
  Scenario Outline: OpenAPI JSON specification generation
    Given a GET request to "/v3/api-docs"
    When the specification contract endpoint is queried
    Then the response status is 200
    And the response returns the complete OpenAPI 3.0 JSON document

    Examples:
      | specEndpoint  | openApiVersion |
      | /v3/api-docs  | 3.0.1          |
