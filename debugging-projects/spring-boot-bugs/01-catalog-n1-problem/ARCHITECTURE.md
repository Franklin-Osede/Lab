# 🏗️ Arquitectura DDD - Catálogo N+1 Problem

## 📁 Estructura de Carpetas

```
01-catalog-n1-problem/
├── src/
│   ├── main/
│   │   ├── java/com/debugging/catalog/
│   │   │   ├── domain/                    # 🎯 Capa de Dominio (DDD Core)
│   │   │   │   ├── model/                 # Entidades, Value Objects, Aggregates
│   │   │   │   ├── repository/            # Interfaces de repositorio
│   │   │   │   └── service/               # Servicios de dominio
│   │   │   ├── application/               # 🚀 Capa de Aplicación
│   │   │   │   ├── usecase/               # Casos de uso (orquestadores)
│   │   │   │   └── dto/                   # Data Transfer Objects
│   │   │   └── infrastructure/            # 🔧 Capa de Infraestructura
│   │   │       ├── repository/            # Implementaciones JPA
│   │   │       ├── rest/                  # Controllers REST
│   │   │       └── config/                # Configuraciones
│   │   └── resources/
│   │       ├── application.yml            # Configuración
│   │       ├── data.sql                   # Datos de prueba
│   │       └── schema.sql                 # Esquema de BD
│   └── test/
│       ├── java/com/debugging/catalog/
│       │   ├── domain/                    # Tests de dominio
│       │   ├── application/               # Tests de casos de uso
│       │   ├── infrastructure/            # Tests de infraestructura
│       │   └── integration/               # Tests de integración
│       └── resources/
│           └── features/                  # Archivos BDD (.feature)
└── pom.xml
```

## 🎯 Plan de Implementación

### Fase 1: Setup Inicial (30 min)
1. **Configuración del proyecto**
   - `pom.xml` con dependencias
   - `application.yml` con configuración
   - Datos de prueba con productos y reseñas

2. **Estructura DDD básica**
   - Entidades: `Product`, `Review`
   - Value Objects: `ProductId`, `ReviewId`, `Rating`
   - Repositorios: `ProductRepository`, `ReviewRepository`

### Fase 2: Implementación con Bug Intencional (45 min)
1. **Capa de Dominio**
   ```java
   // Product.java - Entidad con lógica de negocio
   // Review.java - Value Object
   // ProductRepository.java - Interface
   ```

2. **Capa de Aplicación**
   ```java
   // ListProductsUseCase.java - Caso de uso con bug N+1
   // ProductDTO.java - DTO para respuesta
   ```

3. **Capa de Infraestructura**
   ```java
   // JpaProductRepository.java - Implementación con N+1
   // ProductController.java - REST endpoint
   ```

### Fase 3: Tests BDD y TDD (30 min)
1. **Feature BDD**
   ```gherkin
   Feature: Catálogo de Productos
     Scenario: Listar productos con reseñas
       Given existen 10 productos con reseñas
       When solicito la lista de productos
       Then recibo 10 productos con sus reseñas
       And la respuesta tarda menos de 500ms
   ```

2. **Tests Unitarios**
   - Test de repositorio que falla por N+1
   - Test de caso de uso
   - Test de integración

### Fase 4: Debugging en Vivo (20 min)
1. **Configuración de VS Code**
   - Breakpoints condicionales
   - Logpoints para métricas
   - Watch expressions

2. **Demostración del problema**
   - Ejecutar endpoint con datos
   - Mostrar consultas SQL en logs
   - Medir latencia

### Fase 5: Solución DDD (30 min)
1. **Refactorización**
   - EntityGraph en JPA
   - DTOs optimizados
   - Carga eager controlada

2. **Validación**
   - Tests pasando
   - Métricas mejoradas
   - Performance optimizada

## 🐛 El Bug Intencional: Problema N+1

### ¿Qué es?
- Consulta principal obtiene productos
- Para cada producto, consulta adicional por reseñas
- Resultado: 1 + N consultas = N+1

### Código problemático:
```java
// ❌ MAL: N+1 queries
public List<ProductDTO> listProducts() {
    List<Product> products = productRepository.findAll(); // 1 query
    return products.stream()
        .map(product -> {
            List<Review> reviews = reviewRepository.findByProductId(product.getId()); // N queries
            return ProductDTO.from(product, reviews);
        })
        .collect(Collectors.toList());
}
```

### Solución DDD:
```java
// ✅ BIEN: 1 query optimizada
@Query("SELECT p FROM Product p LEFT JOIN FETCH p.reviews")
List<Product> findAllWithReviews();
```

## 🛠️ Herramientas de Debugging VS Code

### 1. Breakpoints Condicionales
```java
// Breakpoint que se activa solo si hay más de 5 productos
if (products.size() > 5) {
    // Punto de parada aquí
}
```

### 2. Logpoints (sin pausar)
```java
// Log automático de métricas
logger.info("Query executed in {}ms", System.currentTimeMillis() - startTime);
```

### 3. Watch Expressions
- `products.size()` - Cantidad de productos
- `queryCount` - Contador de consultas
- `executionTime` - Tiempo de ejecución

### 4. Debug Console
```java
// Comandos útiles
products.stream().count()  // Contar productos
System.currentTimeMillis() // Timestamp actual
```

## 📊 Métricas a Medir

### Antes (con bug):
- **Latencia**: 2000ms+ para 100 productos
- **Consultas SQL**: 101 queries (1 + 100)
- **Uso de memoria**: Alto por múltiples objetos

### Después (solución):
- **Latencia**: <500ms para 100 productos
- **Consultas SQL**: 1 query optimizada
- **Uso de memoria**: Reducido significativamente

## 🎬 Guión para Video

### 1. Introducción (30s)
"Hoy vamos a resolver un problema clásico de performance: el N+1 query problem en Spring Boot usando DDD"

### 2. Setup del proyecto (1min)
- Mostrar estructura DDD
- Explicar capas y responsabilidades

### 3. Implementación con bug (2min)
- Código que genera N+1
- Ejecutar y mostrar problema

### 4. Debugging en vivo (3min)
- Breakpoints condicionales
- Logs de consultas SQL
- Métricas de performance

### 5. Solución DDD (2min)
- Refactorización siguiendo DDD
- EntityGraph y optimizaciones

### 6. Validación final (1min)
- Tests pasando
- Métricas mejoradas
- Demo del resultado

## 🎯 Resultado Esperado

Al final tendrás:
- ✅ Proyecto Spring Boot con arquitectura DDD limpia
- ✅ Bug N+1 reproducible y documentado
- ✅ Tests BDD/TDD que validan el comportamiento
- ✅ Solución optimizada con métricas
- ✅ Video demostrando debugging profesional
- ✅ Código listo para portfolio

¿Empezamos con la implementación? 🚀
