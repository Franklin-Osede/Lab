Feature: Catálogo de Productos
  Como usuario del sistema
  Quiero ver una lista de productos con sus reseñas
  Para poder tomar decisiones de compra informadas

  Background:
    Given la base de datos está inicializada con datos de prueba
    And existen productos con reseñas en el catálogo

  Scenario: Listar productos con reseñas usando implementación N+1
    When solicito la lista de productos con el endpoint N+1
    Then recibo una lista de productos con sus reseñas
    And la respuesta contiene información de rating promedio
    And la respuesta contiene el número de reseñas por producto
    And puedo ver que la implementación es lenta debido al problema N+1

  Scenario: Listar productos con reseñas usando implementación optimizada
    When solicito la lista de productos con el endpoint optimizado
    Then recibo una lista de productos con sus reseñas
    And la respuesta contiene información de rating promedio
    And la respuesta contiene el número de reseñas por producto
    And puedo ver que la implementación es rápida y eficiente

  Scenario: Comparar performance entre implementaciones
    When ejecuto la comparación de performance
    Then obtengo métricas de tiempo de ejecución
    And puedo ver la mejora de performance
    And la implementación optimizada es significativamente más rápida

  Scenario: Verificar estructura de respuesta de productos
    Given que solicito productos con reseñas
    When recibo la respuesta
    Then cada producto tiene los siguientes campos:
      | id          | número único del producto |
      | name        | nombre del producto       |
      | description | descripción del producto  |
      | price       | precio del producto       |
      | category    | categoría del producto    |
      | averageRating | rating promedio         |
      | reviewCount   | número de reseñas       |
      | reviews       | lista de reseñas        |

  Scenario: Verificar estructura de reseñas
    Given que solicito productos con reseñas
    When recibo la respuesta
    Then cada reseña tiene los siguientes campos:
      | id               | número único de la reseña |
      | userName         | nombre del usuario        |
      | rating           | calificación (1-5)        |
      | comment          | comentario del usuario    |
      | ratingDescription| descripción del rating    |
      | isPositive       | si es reseña positiva     |
      | isNegative       | si es reseña negativa     |
      | createdAt        | fecha de creación         |

  Scenario: Verificar que no hay productos duplicados
    When solicito la lista de productos
    Then no hay productos duplicados en la respuesta
    And cada producto tiene un ID único

  Scenario: Verificar que las reseñas pertenecen a los productos correctos
    When solicito la lista de productos con reseñas
    Then cada reseña tiene el productId correcto
    And las reseñas están ordenadas por fecha de creación
