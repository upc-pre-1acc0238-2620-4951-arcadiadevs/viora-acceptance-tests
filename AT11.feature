Feature: Creation and polygonal delimitation of georeferenced plots (Orchard)
  As a Client Application Developer
  I want to send polygonal vertices in WGS84 format to the API
  so I can register a new plot and persist its agronomic properties

  # Escenario 1: Creación exitosa de parcela
  Scenario Outline: Successful plot creation
    Given a POST request to "/api/v1/plots" with body containing "<name>", "<polygonCoordinates>", "<variety>", <plantDensity> and <plantationYear>
    When the API verifies that the polygon is closed, calculates area in hectares, and validates biological density
    Then the response status is 201
    And the response returns "PlotResource" with assigned id and calculated area

    Examples:
      | name              | polygonCoordinates                                                                 | variety  | plantDensity | plantationYear |
      | San Jeronimo Plot | [[-70.25,-18.05],[-70.24,-18.05],[-70.24,-18.06],[-70.25,-18.06],[-70.25,-18.05]] | CRIOLLA  | 285          | 2018           |
      | La Yarada Plot    | [[-70.26,-18.04],[-70.25,-18.04],[-70.25,-18.05],[-70.26,-18.05],[-70.26,-18.04]] | SEVILLANA| 204          | 2020           |

  # Escenario 2: Geometría poligonal inválida
  Scenario Outline: Invalid polygonal geometry
    Given a POST request to "/api/v1/plots" with unclosed polygon coordinates or fewer than 3 vertices: "<polygonCoordinates>"
    When the API validates spatial geometry
    Then the response status is 400
    And the response indicates coordinate inconsistency

    Examples:
      | polygonCoordinates                                 | reason            |
      | [[-70.25,-18.05],[-70.24,-18.05]]                   | fewer than 3 points |
      | [[-70.25,-18.05],[-70.24,-18.05],[-70.24,-18.06]] | unclosed polygon  |
