Feature: Localization and internationalized messages via Accept-Language header (Shared)
  As a Core Platform Engineer
  I want to configure the locale resolver and MessageSource catalogs in the backend
  so I can intercept the HTTP Accept-Language header and deliver RFC 7807 messages in Spanish or English

  # Escenario 1: Respuesta localizada en base a la cabecera HTTP
  Scenario Outline: Localized error response based on Accept-Language header
    Given a request to an endpoint with header "Accept-Language: <langHeader>" triggering an exception
    When the centralized interceptor captures the failure and invokes MessageSource
    Then the response status is <statusCode>
    And the RFC 7807 problem detail is translated into "<expectedLanguage>"

    Examples:
      | langHeader | statusCode | expectedLanguage |
      | en         | 400        | English          |
      | es         | 400        | Spanish          |

  # Escenario 2: Aplicación del idioma predeterminado ante omisión o valor no soportado
  Scenario Outline: Default language fallback upon omission or unsupported locale
    Given an HTTP request received without Accept-Language header or with unsupported "<unsupportedLang>"
    When the interceptor processes the domain or validation failure
    Then the system applies default Spanish ("es") locale and delivers messages in Spanish

    Examples:
      | unsupportedLang | defaultLocale |
      | fr              | es            |
      | de              | es            |
