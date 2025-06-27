Feature: Pruebas de la API de superheroes de Marvel

 Background:
 * configure ssl = true
 * url 'http://localhost:8080/aaizaga/api'

 Scenario: Crear superheroe exitosamente -> debe retornar 201 y los datos del superherore creado
  Given path 'characters'
  And request
   """
   {
    "name": "Batman",
    "alterego": "Bruce Wayne",
    "description": "Un hombre murciélago que lucha contra el crimen",
    "powers": [ "Inteligencia", "Habilidad de combate", "Tecnología avanzada" ]
   }
   """
  When method post
  Then status 201
  And match response contains { name: "Batman", alterego: "Bruce Wayne" }
  And match response.powers contains ["Inteligencia", "Habilidad de combate", "Tecnología avanzada"]

 Scenario: Crear superheroe con nombre duplicado -> debe retornar 400 y mensaje de error
  Given path 'characters'
  And request
   """
   {
    "name": "Batman",
    "alterego": "Bruce Wayne",
    "description": "El caballero oscuro",
    "powers": ["Fuerza"]
   }
   """
  When method post
  Then status 400
  And match response == { error: "Character name already exists" }

 Scenario: Crear superheroe con campos requeridos vacíos -> debe retornar 400 y mensajes de error
  Given path 'characters'
  And request
   """
   {
    "name": "",
    "alterego": "",
    "description": "",
    "powers": []
   }
   """
  When method post
  Then status 400
  And match response ==  {  name: "Name is required",  alterego: "Alterego is required",  description: "Description is required",  powers: "Powers are required"  }

 Scenario: Actualizar superheroe exitosamente -> debe retornar 200 y datos actualizados
  Given path 'characters', '1'
  And request
   """
   {
    "name": "Batman",
    "alterego": "Bruce Wayne",
    "description": "El caballero de la noche",
    "powers": ["Fuerza", "Inteligencia"]
   }
   """
  When method put
  Then status 200
  And match response contains { description: "El caballero de la noche" }
  And match response.powers contains ["Fuerza", "Inteligencia"]


 Scenario: Actualizar superheroe que no existe -> debe retornar 404 y mensaje de error
  Given path 'characters', '999'
  And request
   """
   {
    "name": "Iron Man",
    "alterego": "Tony Stark",
    "description": "Billonario genio que construye armaduras",
    "powers": ["Fuerza", "Tecnologia avanzada"]
   }
   """
  When method put
  Then status 404
  And match response == { error: "Character not found" }


 Scenario: Obtener todos los superheroes -> debe retornar 200 y lista vacía
  Given path 'characters'
  When method get
  Then status 200
  And match response != []

 Scenario: Obtener superheroe por ID existente -> debe retornar 200 y datos del superheroe
  Given path 'characters', '1'
  When method get
  Then status 200
  And match response contains { id: 1, name: "Batman", alterego: "Bruce Wayne" }
  And match response.powers contains ["Fuerza", "Inteligencia"]


 Scenario: Obtener superheroe por ID que no existe -> debe retornar 404 y mensaje de error
  Given path 'characters', '999'
  When method get
  Then status 404
  And match response == { error: "Character not found" }


 Scenario: Eliminar superheroe existente -> debe retornar 204 sin contenido
  Given path 'characters', '1'
  When method delete
  Then status 204

 Scenario: Eliminar superheroe que no existe -> debe retornar 404 y mensaje de error
  Given path 'characters', '999'
  When method delete
  Then status 404
  And match response == { error: "Character not found" }
