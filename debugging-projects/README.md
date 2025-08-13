# 🐛 Proyectos de Debugging - Spring Boot & Angular

Esta sección contiene proyectos diseñados específicamente para demostrar técnicas avanzadas de debugging, testing y arquitectura de software.

## 🎯 Objetivo

Demostrar dominio experto en:
- **Debugging avanzado** con breakpoints condicionales, logpoints y métricas
- **TDD/BDD** con Cucumber y testing guiado por comportamiento
- **DDD (Domain-Driven Design)** con arquitectura limpia
- **Observabilidad** con Spring Boot Actuator y Micrometer
- **Resiliencia** con patrones de circuit breaker y retry

## 📁 Estructura del Proyecto

```
debugging-projects/
├── spring-boot-bugs/           # 5 proyectos con bugs intencionales
│   ├── 01-catalog-n1-problem/  # Problema N+1 en consultas
│   ├── 02-booking-validation/  # Validación de fechas y errores
│   ├── 03-login-performance/   # Latencia y caché
│   ├── 04-payment-resilience/  # Timeouts y reintentos
│   └── 05-inventory-concurrency/ # Concurrencia y bloqueo optimista
├── angular-bugs/               # Proyectos Angular equivalentes
│   ├── 01-catalog-performance/
│   ├── 02-booking-forms/
│   ├── 03-auth-optimization/
│   ├── 04-payment-ui/
│   └── 05-inventory-management/
└── shared/                     # Recursos compartidos
    ├── postman-collections/    # Colecciones para testing
    ├── docker-compose/         # Infraestructura local
    └── documentation/          # Guías y documentación
```

## 🚀 Tecnologías Utilizadas

### Backend (Spring Boot)
- **Spring Boot 3.x** con Java 17+
- **Spring Data JPA** con H2/PostgreSQL
- **Spring WebFlux** para casos reactivos
- **Spring Security** para autenticación
- **Resilience4j** para patrones de resiliencia
- **Micrometer** para métricas y observabilidad
- **Cucumber** para BDD
- **JUnit 5** con Mockito para testing

### Frontend (Angular)
- **Angular 17+** con TypeScript
- **Angular Material** para UI
- **RxJS** para programación reactiva
- **Jasmine/Karma** para testing
- **Cypress** para E2E testing
- **Angular DevTools** para debugging

## 🎬 Flujo de Demostración

Cada proyecto sigue este patrón:

1. **Presentación del problema** (30s)
   - Explicar el contexto de negocio
   - Mostrar el comportamiento esperado vs actual

2. **Test-Driven Development** (1min)
   - Escribir test BDD en Gherkin
   - Implementar test unitario que falla
   - Mostrar el "test rojo"

3. **Debugging en vivo** (2-3min)
   - Breakpoints condicionales
   - Logpoints y métricas
   - Análisis de performance
   - Identificación del root cause

4. **Solución con DDD** (2-3min)
   - Refactorización siguiendo principios DDD
   - Implementación de la solución
   - Validación de arquitectura

5. **Validación final** (1min)
   - Test verde
   - Métricas mejoradas
   - Demo del comportamiento corregido

## 📊 Métricas de Éxito

Para cada proyecto mediremos:
- **Performance**: Latencia, throughput, uso de memoria
- **Reliability**: Tasa de errores, disponibilidad
- **Maintainability**: Cobertura de tests, complejidad ciclomática
- **User Experience**: Tiempo de respuesta, feedback visual

## 🎯 Casos de Estudio

### 1. Catálogo con Problema N+1
**Problema**: Consultas ineficientes que generan N+1 queries
**Solución**: EntityGraph, DTOs optimizados, paginación
**DDD**: Product Aggregate, Review Value Object

### 2. Reservas con Validación
**Problema**: Validación inconsistente de fechas
**Solución**: Bean Validation, manejo global de errores
**DDD**: Booking Aggregate, DateRange Value Object

### 3. Login con Performance
**Problema**: Autenticación lenta sin caché
**Solución**: Redis cache, consultas optimizadas
**DDD**: User Aggregate, Authentication Service

### 4. Pagos con Resiliencia
**Problema**: Sin manejo de timeouts y reintentos
**Solución**: Circuit breaker, retry policies
**DDD**: Payment Aggregate, External Service Adapter

### 5. Inventario con Concurrencia
**Problema**: Race conditions en stock
**Solución**: Optimistic locking, versioning
**DDD**: Inventory Aggregate, Stock Value Object

## 🛠️ Setup Local

```bash
# Clonar y configurar
git clone <repo>
cd debugging-projects

# Backend
cd spring-boot-bugs/01-catalog-n1-problem
./mvnw spring-boot:run

# Frontend
cd angular-bugs/01-catalog-performance
npm install
ng serve
```

## 📚 Recursos Adicionales

- [Spring Boot Debugging Guide](https://spring.io/guides/gs/debugging/)
- [Angular DevTools](https://angular.io/guide/devtools)
- [DDD Reference](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [BDD with Cucumber](https://cucumber.io/docs/cucumber/)

---

**¿Listo para convertirte en un experto en debugging?** 🚀
