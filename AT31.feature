Feature: Centralized exception handling and RFC 7807 problem details (Shared)
  As a Core Platform Engineer
  I want to implement a global exception interceptor in the backend
  so I can guarantee that all error responses comply with RFC 7807 Problem Details without exposing internal traces

  # Escenario 1: Intercepción de excepciones de validación y dominio
  Scenario Outline: Validation and domain exception interception under RFC 7807
    Given a request to an endpoint triggering a domain exception: "<endpoint>", "<triggerException>"
    When the centralized interceptor captures the exception
    Then the response status is <statusCode>
    And the response body is "application/problem+json" with type, title, status, detail, instance and timestamp

    Examples:
      | endpoint                          | triggerException         | statusCode |
      | /api/v1/plots                     | MethodArgumentNotValid   | 400        |
      | /api/v1/plots/plot-not-found      | ResourceNotFoundException| 404        |
      | /api/v1/plots/plot-duplicate-name | DuplicateResourceException| 409       |

  # Escenario 2: Protección ante fallas no controladas
  Scenario Outline: Protection against uncontrolled internal server failures
    Given an unforeseen internal runtime error in the application
    When the global exception handler processes the failure
    Then the response status is 500
    And the response returns a sanitized message without disclosing database or OS stacktraces

    Examples:
      | errorType             | expectedTitle          |
      | NullPointerException  | Internal Server Error  |
