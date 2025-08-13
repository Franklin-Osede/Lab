# 🐛 Spring Boot Debugging Projects - Plan Maestro

## 🎯 Objetivo General

Demostrar dominio experto en debugging, testing y arquitectura de software a través de 5 proyectos Spring Boot con bugs intencionales que se resuelven aplicando DDD, TDD y BDD.

## 📋 Proyectos Planificados

### 1. 🛍️ **Catálogo N+1 Problem** (`01-catalog-n1-problem`)
**Problema**: Consultas ineficientes que generan N+1 queries
**Bug Intencional**: Cada producto dispara consulta adicional por reseñas
**Solución DDD**: EntityGraph, DTOs optimizados, carga eager controlada
**Tiempo**: 2-3 horas

### 2. 📅 **Reservas con Validación** (`02-booking-validation`)
**Problema**: Validación inconsistente de fechas y errores no estandarizados
**Bug Intencional**: Permite reservas con fecha fin < fecha inicio
**Solución DDD**: Bean Validation, manejo global de errores, DateRange VO
**Tiempo**: 2 horas

### 3. 🔐 **Login con Performance** (`03-login-performance`)
**Problema**: Autenticación lenta sin caché ni optimizaciones
**Bug Intencional**: Consulta secuencial de usuarios sin índices
**Solución DDD**: Redis cache, consultas optimizadas, métricas
**Tiempo**: 2 horas

### 4. 💳 **Pagos con Resiliencia** (`04-payment-resilience`)
**Problema**: Sin manejo de timeouts, reintentos ni circuit breaker
**Bug Intencional**: Llamadas externas sin control de errores
**Solución DDD**: Resilience4j, retry policies, external service adapter
**Tiempo**: 2-3 horas

### 5. 📦 **Inventario con Concurrencia** (`05-inventory-concurrency`)
**Problema**: Race conditions en stock sin control de concurrencia
**Bug Intencional**: Múltiples reservas simultáneas generan stock negativo
**Solución DDD**: Optimistic locking, versioning, aggregate boundaries
**Tiempo**: 3 horas

## 🏗️ Arquitectura DDD Consistente

Cada proyecto sigue la misma estructura:

```
src/main/java/com/debugging/{project}/
├── domain/                    # 🎯 Capa de Dominio
│   ├── model/                 # Entidades, Value Objects, Aggregates
│   ├── repository/            # Interfaces de repositorio
│   └── service/               # Servicios de dominio
├── application/               # 🚀 Capa de Aplicación
│   ├── usecase/               # Casos de uso (orquestadores)
│   └── dto/                   # Data Transfer Objects
└── infrastructure/            # 🔧 Capa de Infraestructura
    ├── repository/            # Implementaciones JPA
    ├── rest/                  # Controllers REST
    └── config/                # Configuraciones
```

## 🧪 Testing Strategy

### BDD (Behavior Driven Development)
- **Cucumber** con archivos `.feature`
- Escenarios en lenguaje natural
- Step definitions que llaman a endpoints reales

### TDD (Test Driven Development)
- **JUnit 5** con Mockito
- Tests unitarios para cada capa
- Tests de integración con `@SpringBootTest`

### Testing Pyramid
```
    /\
   /  \     E2E Tests (Cucumber)
  /____\    
 /      \   Integration Tests
/________\  Unit Tests
```

## 🛠️ Herramientas de Debugging VS Code

### 1. Breakpoints Avanzados
```java
// Breakpoint condicional
if (products.size() > 10) {
    // Solo se activa con más de 10 productos
}

// Breakpoint con expresión
product.getReviews().size() > 5
```

### 2. Logpoints (Sin Pausar)
```java
// Log automático de métricas
logger.info("Query count: {}, Time: {}ms", queryCount, executionTime);
```

### 3. Watch Expressions
- `System.currentTimeMillis() - startTime` - Tiempo de ejecución
- `products.stream().count()` - Cantidad de productos
- `queryCount` - Contador de consultas SQL

### 4. Debug Console
```java
// Comandos útiles durante debugging
products.stream().mapToInt(p -> p.getReviews().size()).sum()
System.currentTimeMillis()
Thread.currentThread().getName()
```

## 📊 Métricas y Observabilidad

### Spring Boot Actuator
- `/actuator/health` - Estado de la aplicación
- `/actuator/metrics` - Métricas de performance
- `/actuator/prometheus` - Métricas para Prometheus

### Micrometer
```java
@Timed("catalog.list.products")
@Counted("catalog.list.products.count")
public List<ProductDTO> listProducts() {
    // Métricas automáticas
}
```

### Logging Estrcuturado
```java
logger.info("Processing {} products", products.size(), 
    Map.of("queryCount", queryCount, "executionTime", executionTime));
```

## 🎬 Flujo de Demostración Estándar

### 1. **Presentación del Problema** (30s)
- Contexto de negocio
- Comportamiento esperado vs actual
- Impacto en el usuario

### 2. **Test-Driven Development** (1min)
- Escribir feature BDD
- Implementar test que falla
- Mostrar "test rojo"

### 3. **Debugging en Vivo** (2-3min)
- Breakpoints condicionales
- Logpoints y métricas
- Análisis de performance
- Identificación del root cause

### 4. **Solución con DDD** (2-3min)
- Refactorización siguiendo DDD
- Implementación de la solución
- Validación de arquitectura

### 5. **Validación Final** (1min)
- Test verde
- Métricas mejoradas
- Demo del comportamiento corregido

## 🚀 Tecnologías Stack

### Backend
- **Spring Boot 3.2** con Java 17
- **Spring Data JPA** con H2/PostgreSQL
- **Spring Security** para autenticación
- **Resilience4j** para patrones de resiliencia
- **Micrometer** para métricas
- **Cucumber** para BDD
- **JUnit 5** con Mockito

### Herramientas de Desarrollo
- **VS Code** con extensiones Java
- **Spring Boot DevTools** para hot reload
- **H2 Console** para debugging de BD
- **Postman** para testing de APIs

## 📈 Métricas de Éxito

### Performance
- **Latencia**: Reducción del 70%+ en tiempo de respuesta
- **Throughput**: Aumento del 50%+ en requests/segundo
- **Uso de memoria**: Reducción del 40%+ en consumo

### Quality
- **Cobertura de tests**: 90%+ en todas las capas
- **Código limpio**: Sin code smells, alta legibilidad
- **Arquitectura**: Separación clara de responsabilidades

### User Experience
- **Tiempo de respuesta**: <500ms para operaciones críticas
- **Feedback visual**: Mensajes de error claros y útiles
- **Consistencia**: Comportamiento predecible en todos los casos

## 🎯 Resultado Final

Al completar los 5 proyectos tendrás:

✅ **Portfolio técnico** con casos reales de debugging
✅ **Demostración de expertise** en Spring Boot y DDD
✅ **Videos profesionales** mostrando debugging en vivo
✅ **Código de calidad** listo para mostrar a empleadores
✅ **Conocimiento profundo** de patrones de debugging

## 📅 Cronograma Sugerido

- **Semana 1**: Proyectos 1-2 (Catálogo y Reservas)
- **Semana 2**: Proyectos 3-4 (Login y Pagos)
- **Semana 3**: Proyecto 5 (Inventario) + Refinamiento
- **Semana 4**: Grabación de videos + Documentación

¿Listo para convertirte en un experto en debugging? 🚀
