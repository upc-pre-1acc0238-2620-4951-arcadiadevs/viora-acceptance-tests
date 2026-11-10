Feature: Field note photo download (Orchard)
  As a Client Application Developer
  I want to download the photo of a note via GET to /api/v1/plots/{plotId}/field-notes/{noteId}/photo
  so I can see the recorded evidence

  # Escenario 1: Descarga exitosa
  Scenario Outline: Successful download
    Given a GET request to "/api/v1/plots/<plotId>/field-notes/<noteId>/photo" sent by "<actor>" for a note with a photo
    When the API reads the image
    Then the response status is 200
    And the response returns its content

    Examples:
      | plotId          | noteId                               | actor           |
      | plot-yarada-001 | 6c8e0a2b-4d6f-4a8c-9e1b-3d5f7a9c1e23 | usr-farmer-0042 |

  # Escenario 2: Fotografía no disponible
  Scenario Outline: Photo not available
    Given a GET request to "/api/v1/plots/<plotId>/field-notes/<noteId>/photo" sent by "<actor>" for an unknown plot or note, or a note without photo
    When the API searches the image
    Then the response status is 404

    Examples:
      | plotId          | noteId                               | actor           |
      | plot-yarada-001 | 6c8e0a2b-4d6f-4a8c-9e1b-3d5f7a9c1e23 | usr-farmer-0042 |
