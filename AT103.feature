Feature: Dossier authenticity verification (Harvest)
  As a Client Application Developer
  I want to verify a dossier by its fingerprint via GET to /api/v1/agronomic-dossiers/verifications/{verificationHash}
  so I can confirm the document was issued by Viora and was not changed

  # Escenario 1: Código válido
  Scenario Outline: Valid code
    Given a GET request to "/api/v1/agronomic-dossiers/verifications/<verificationHash>" sent by "<actor>" with a fingerprint that matches a stored dossier
    When the API searches the fingerprint
    Then the response status is 200
    And the response returns the plot and campaign

    Examples:
      | verificationHash                                                 | actor            |
      | 9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08 | anonymous-client |

  # Escenario 2: Formato inválido
  Scenario Outline: Invalid format
    Given a GET request to "/api/v1/agronomic-dossiers/verifications/<verificationHash>" sent by "<actor>" with a code that is not 64 hexadecimal characters
    When the API validates the code
    Then the response status is 400

    Examples:
      | verificationHash                                                 | actor            |
      | 9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08 | anonymous-client |

  # Escenario 3: Código sin coincidencia
  Scenario Outline: Code without match
    Given a GET request to "/api/v1/agronomic-dossiers/verifications/<verificationHash>" sent by "<actor>" with a fingerprint that matches no dossier
    When the API searches the fingerprint
    Then the response status is 404

    Examples:
      | verificationHash                                                 | actor            |
      | 9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08 | anonymous-client |
