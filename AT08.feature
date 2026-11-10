Feature: Activation code batch generation for cooperative members with quota reservation (Membership)
  As a Client Application Developer
  I want to issue a batch of activation codes with quantity, validity days and hectares per code via POST to /api/v1/invitation-codes
  so I can invite members while reserving seats and hectares of the license

  # Escenario 1: Generación exitosa de lote con reserva atómica de plazas y hectáreas
  Scenario Outline: Successful batch generation with atomic seat and hectare reservation
    Given a POST request to "/api/v1/invitation-codes" sent by "<actor>" with quantity, validity days and hectares per code
    When the API reserves the seats and hectares and issues the codes
    Then the response status is 201
    And the response returns the issued codes

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Escenario 2: Cupo o hectáreas insuficientes en la licencia colectiva
  Scenario Outline: Insufficient seats or hectares in the license
    Given a POST request to "/api/v1/invitation-codes" sent by "<actor>" for a batch that exceeds the free seats or hectares
    When the API checks the license balance
    Then the response status is 400
    And the response indicates there is not enough quota

    Examples:
      | actor            |
      | usr-manager-0007 |

  # Escenario 3: Acceso no autorizado para usuarios sin rol de gestor técnico
  Scenario Outline: Unauthorized access for users without the technical manager role
    Given a POST request to "/api/v1/invitation-codes" sent by "<actor>" from a user without the technical manager role or without a license in force
    When the API checks the access
    Then the response status is 403

    Examples:
      | actor           |
      | usr-farmer-0042 |
