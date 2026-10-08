Feature: Collegiate cryptographic certification of immutable agronomic dossier (Harvest)
  As a Client Application Developer
  I want to submit collegiate dossier certification via POST to /api/v1/plots/{plotId}/certifications
  so I can seal the technical campaign dossier and generate an immutable SHA-256 hash for non-repudiation

  # Escenario 1: Emisión exitosa de certificación colegiada y hash SHA-256
  Scenario Outline: Successful collegiate certification emission and SHA-256 hash
    Given a POST request to "/api/v1/plots/<plotId>/certifications" with campaignYear <campaignYear>, auditorSignature "<auditorSignature>", certifiedBy "<certifiedBy>" and cipNumber "<cipNumber>"
    When the API confirms prior harvest settlement, compiles the dossier and calculates immutable SHA-256 hash
    Then the response status is 201
    And the response returns "DossierCertificationResource" with verificationHash and emits AgronomicDossierGeneratedEvent

    Examples:
      | plotId            | campaignYear | auditorSignature      | certifiedBy       | cipNumber | notes               |
      | plot-jeronomo-001 | 2025         | SIG_ECDSA_SHA256_A9F2 | Ing. Carlos Perez | CIP-184920 | Complete audit 2025 |

  # Escenario 2: Datos de firma o colegiatura inválidos
  Scenario Outline: Invalid signature or CIP registration data
    Given a POST request with blank signature or CIP exceeding 20 characters: "<auditorSignature>", "<cipNumber>"
    When the API processes and validates command attributes
    Then the response status is 400

    Examples:
      | plotId            | campaignYear | auditorSignature | cipNumber            | reason             |
      | plot-jeronomo-001 | 2025         |                  | CIP-184920           | blank signature    |
      | plot-jeronomo-001 | 2025         | SIG_VALID        | CIP-123456789012345678901 | CIP over 20 chars  |

  # Escenario 3: Parcela no encontrada o inactiva
  Scenario Outline: Plot not found for certification
    Given a POST request directed to a non-existent plotId: "<plotId>"
    When the API evaluates plot existence
    Then the response status is 404

    Examples:
      | plotId                | campaignYear |
      | plot-non-existent-999 | 2025         |

  # Escenario 4: Precondición incumplida por campaña sin liquidación formal
  Scenario Outline: Precondition unfulfilled due to uncompleted settlement
    Given a POST request for a campaign year without prior formal harvest settlement: <campaignYear>
    When the domain service validates documentary certification preconditions
    Then the response status is 422
    And the response indicates unprocessable content under RFC 7807

    Examples:
      | plotId            | campaignYear |
      | plot-jeronomo-001 | 2026         |

  # Escenario 5: Conflicto por expediente previamente certificado
  Scenario Outline: Conflict when dossier is already certified
    Given a POST request for a campaign that already possesses an immutable certified dossier: <campaignYear>
    When the system verifies campaign certification uniqueness
    Then the response status is 409

    Examples:
      | plotId            | campaignYear |
      | plot-jeronomo-001 | 2024         |
