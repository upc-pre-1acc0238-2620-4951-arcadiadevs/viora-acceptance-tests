Feature: Field note photo attachment (Orchard)
  As a Client Application Developer
  I want to attach a photo to a note via PUT to /api/v1/plots/{plotId}/field-notes/{noteId}/photo
  so I can document an observation visually

  # Escenario 1: Fotografía almacenada
  Scenario Outline: Photo stored
    Given a PUT request to "/api/v1/plots/<plotId>/field-notes/<noteId>/photo" sent by "<actor>" with a JPEG or PNG image up to 1 MiB
    When the API stores the image and replaces the previous one
    Then the response status is 200
    And the response returns the note

    Examples:
      | plotId          | noteId                               | actor           |
      | plot-yarada-001 | 6c8e0a2b-4d6f-4a8c-9e1b-3d5f7a9c1e23 | usr-farmer-0042 |

  # Escenario 2: Imagen inválida
  Scenario Outline: Invalid image
    Given a PUT request to "/api/v1/plots/<plotId>/field-notes/<noteId>/photo" sent by "<actor>" with an empty, too large or non JPEG or PNG content
    When the API validates the image
    Then the response status is 400

    Examples:
      | plotId          | noteId                               | actor           |
      | plot-yarada-001 | 6c8e0a2b-4d6f-4a8c-9e1b-3d5f7a9c1e23 | usr-farmer-0042 |

  # Escenario 3: Parcela o nota no encontrada
  Scenario Outline: Plot or note not found
    Given a PUT request to "/api/v1/plots/<plotId>/field-notes/<noteId>/photo" sent by "<actor>" for an unknown plot or note
    When the API searches them
    Then the response status is 404

    Examples:
      | plotId          | noteId                               | actor           |
      | plot-yarada-001 | 6c8e0a2b-4d6f-4a8c-9e1b-3d5f7a9c1e23 | usr-farmer-0042 |
