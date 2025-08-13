# 🐛 Catálogo N+1 Problem - Spring Boot Demo

## 🎯 Objetivo

Demostrar el problema clásico de **N+1 queries** en Spring Boot y cómo solucionarlo aplicando **Domain-Driven Design (DDD)** y optimizaciones de JPA.

## 🐛 El Problema N+1

### ¿Qué es?
- **1 query** para obtener productos
- **N queries** adicionales para obtener reseñas de cada producto
- **Total**: 1 + N = N+1 queries

### Ejemplo con 30 productos:
- ❌ **N+1**: 1 query + 30 queries = **31 queries**
- ✅ **Optimizado**: 1 query con JOIN FETCH = **1 query**

## 🏗️ Arquitectura DDD

```
src/main/java/com/debugging/catalog/
├── domain/                    # 🎯 Capa de Dominio
│   ├── model/                 # Entidades y Value Objects
│   │   ├── Product.java       # Aggregate Root
│   │   └── Review.java        # Entidad del Aggregate
│   └── repository/            # Interfaces de repositorio
│       ├── ProductRepository.java
│       └── ReviewRepository.java
├── application/               # 🚀 Capa de Aplicación
│   ├── usecase/               # Casos de uso
│   │   └── ListProductsUseCase.java
│   └── dto/                   # Data Transfer Objects
│       ├── ProductDTO.java
│       └── ReviewDTO.java
└── infrastructure/            # 🔧 Capa de Infraestructura
    ├── repository/            # Implementaciones JPA
    │   ├── JpaProductRepository.java
    │   └── JpaReviewRepository.java
    └── rest/                  # Controllers REST
        └── ProductController.java
```

## 🚀 Cómo Ejecutar

### 1. Clonar y configurar
```bash
cd debugging-projects/spring-boot-bugs/01-catalog-n1-problem
./mvnw spring-boot:run
```

### 2. Acceder a la aplicación
- **Aplicación**: http://localhost:8080/api/v1
- **H2 Console**: http://localhost:8080/h2-console
- **Actuator**: http://localhost:8080/actuator

## 📊 Endpoints Disponibles

### ❌ Endpoint con Bug N+1
```bash
GET /api/v1/products/with-n1-bug
```
**Comportamiento**: Lento, genera N+1 queries

### ✅ Endpoint Optimizado
```bash
GET /api/v1/products/optimized
```
**Comportamiento**: Rápido, 1 query optimizada

### 📈 Comparación de Performance
```bash
GET /api/v1/products/performance-comparison
```
**Resultado**: Métricas comparativas

### 🏥 Health Check
```bash
GET /api/v1/products/health
```
**Resultado**: Estado de la aplicación

## 🛠️ Debugging en VS Code

### 1. Breakpoints Condicionales
```java
// En ListProductsUseCase.java línea 58
if (products.size() > 5) {
    // Breakpoint aquí para productos con muchas reseñas
}
```

### 2. Logpoints para Métricas
```java
// En ProductController.java línea 45
logger.info("🐛 N+1 buggy endpoint completed in {}ms for {} products", 
           executionTime, products.size());
```

### 3. Watch Expressions
- `products.size()` - Cantidad de productos
- `executionTime` - Tiempo de ejecución
- `System.currentTimeMillis() - startTime` - Tiempo transcurrido

### 4. Debug Console
```java
// Comandos útiles durante debugging
products.stream().count()
products.stream().mapToInt(p -> p.getReviews().size()).sum()
System.currentTimeMillis()
```

## 🧪 Testing

### Tests Unitarios
```bash
./mvnw test
```

### Tests BDD (Cucumber)
```bash
./mvnw test -Dtest=CucumberTest
```

### Tests de Integración
```bash
./mvnw verify
```

## 📊 Métricas y Observabilidad

### Actuator Endpoints
- **Health**: `/actuator/health`
- **Metrics**: `/actuator/metrics`
- **Prometheus**: `/actuator/prometheus`

### Métricas Personalizadas
- `catalog.list.products.with.n1.bug` - Timer para implementación N+1
- `catalog.list.products.optimized` - Timer para implementación optimizada
- `catalog.products.controller` - Timer para operaciones del controller

## 🔍 Cómo Reproducir el Problema

### 1. Ejecutar endpoint N+1
```bash
curl http://localhost:8080/api/v1/products/with-n1-bug
```

### 2. Observar logs SQL
```
Hibernate: select product0_.id as id1_0_, product0_.category as category2_0_, ...
Hibernate: select reviews0_.product_id as product_3_1_, reviews0_.id as id1_1_, ...
Hibernate: select reviews0_.product_id as product_3_1_, reviews0_.id as id1_1_, ...
Hibernate: select reviews0_.product_id as product_3_1_, reviews0_.id as id1_1_, ...
... (repetido N veces)
```

### 3. Ejecutar endpoint optimizado
```bash
curl http://localhost:8080/api/v1/products/optimized
```

### 4. Observar una sola query
```
Hibernate: select distinct product0_.id as id1_0_, product0_.category as category2_0_, ...
```

## 🎯 Solución Implementada

### ❌ Código Problemático
```java
// N+1 queries
List<Product> products = productRepository.findAll(); // 1 query
return products.stream()
    .map(product -> {
        List<Review> reviews = reviewRepository.findByProductId(product.getId()); // N queries
        return ProductDTO.from(product, reviews);
    })
    .collect(Collectors.toList());
```

### ✅ Código Optimizado
```java
// 1 query optimizada
@Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.reviews")
List<Product> findAllWithReviews();

// Uso
List<Product> products = productRepository.findAllWithReviews(); // 1 query
return products.stream()
    .map(ProductDTO::fromWithReviews)
    .collect(Collectors.toList());
```

## 📈 Resultados Esperados

### Performance
- **N+1**: ~2000ms para 30 productos
- **Optimizado**: ~200ms para 30 productos
- **Mejora**: ~90% más rápido

### Consultas SQL
- **N+1**: 31 queries (1 + 30)
- **Optimizado**: 1 query
- **Reducción**: 97% menos queries

## 🎬 Guión para Video

### 1. Introducción (30s)
"Hoy vamos a resolver el problema N+1 en Spring Boot usando DDD"

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

## 🎯 Aprendizajes Clave

1. **DDD**: Separación clara de responsabilidades por capas
2. **N+1 Problem**: Identificación y reproducción del problema
3. **JOIN FETCH**: Solución técnica con JPA
4. **Observabilidad**: Métricas y logging para debugging
5. **Testing**: TDD y BDD para validar comportamiento

## 📚 Recursos Adicionales

- [Spring Boot Debugging Guide](https://spring.io/guides/gs/debugging/)
- [JPA Best Practices](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)
- [DDD Reference](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [N+1 Query Problem](https://stackoverflow.com/questions/97197/what-is-the-n1-selects-problem-in-orm-object-relational-mapping)

---

**¿Listo para convertirte en un experto en debugging?** 🚀
