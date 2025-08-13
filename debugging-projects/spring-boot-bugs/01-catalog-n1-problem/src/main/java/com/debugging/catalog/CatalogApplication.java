package com.debugging.catalog;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

/**
 * Main Spring Boot Application
 * 
 * Features enabled:
 * - JPA/Hibernate for persistence
 * - Actuator for metrics and health checks
 * - Caching for performance optimization
 * - Micrometer for observability
 */
@SpringBootApplication
@EnableCaching
public class CatalogApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(CatalogApplication.class, args);
    }
}
