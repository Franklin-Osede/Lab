package com.debugging.catalog.infrastructure.rest;

import com.debugging.catalog.application.dto.ProductDTO;
import com.debugging.catalog.application.usecase.ListProductsUseCase;
import io.micrometer.core.annotation.Timed;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * REST Controller for Product operations
 * 
 * Endpoints to demonstrate N+1 problem and its solution
 */
@RestController
@RequestMapping("/products")
@Timed("catalog.products.controller")
public class ProductController {
    
    private static final Logger logger = LoggerFactory.getLogger(ProductController.class);
    
    private final ListProductsUseCase listProductsUseCase;
    
    public ProductController(ListProductsUseCase listProductsUseCase) {
        this.listProductsUseCase = listProductsUseCase;
    }
    
    /**
     * ❌ BUGGY ENDPOINT: Demonstrates N+1 problem
     * 
     * This endpoint will cause N+1 queries:
     * - 1 query to get all products
     * - N queries to get reviews for each product
     * 
     * @return List of products with reviews (slow due to N+1)
     */
    @GetMapping("/with-n1-bug")
    @Timed("catalog.products.list.with.n1.bug")
    public ResponseEntity<List<ProductDTO>> listProductsWithN1Bug() {
        logger.info("🐛 Executing N+1 buggy endpoint");
        long startTime = System.currentTimeMillis();
        
        List<ProductDTO> products = listProductsUseCase.executeWithN1Bug();
        
        long executionTime = System.currentTimeMillis() - startTime;
        logger.info("🐛 N+1 buggy endpoint completed in {}ms for {} products", 
                   executionTime, products.size());
        
        return ResponseEntity.ok(products);
    }
    
    /**
     * ✅ OPTIMIZED ENDPOINT: Demonstrates solution to N+1
     * 
     * This endpoint uses optimized queries:
     * - 1 query to get all products with reviews
     * 
     * @return List of products with reviews (fast, optimized)
     */
    @GetMapping("/optimized")
    @Timed("catalog.products.list.optimized")
    public ResponseEntity<List<ProductDTO>> listProductsOptimized() {
        logger.info("✅ Executing optimized endpoint");
        long startTime = System.currentTimeMillis();
        
        List<ProductDTO> products = listProductsUseCase.executeOptimized();
        
        long executionTime = System.currentTimeMillis() - startTime;
        logger.info("✅ Optimized endpoint completed in {}ms for {} products", 
                   executionTime, products.size());
        
        return ResponseEntity.ok(products);
    }
    
    /**
     * 📊 PERFORMANCE COMPARISON: Compare both implementations
     * 
     * @return Performance metrics comparing N+1 vs optimized
     */
    @GetMapping("/performance-comparison")
    @Timed("catalog.products.performance.comparison")
    public ResponseEntity<Map<String, Object>> comparePerformance() {
        logger.info("📊 Starting performance comparison");
        
        ListProductsUseCase.PerformanceComparisonResult result = 
            listProductsUseCase.comparePerformance();
        
        Map<String, Object> response = Map.of(
            "n1ExecutionTime", result.getN1ExecutionTime(),
            "optimizedExecutionTime", result.getOptimizedExecutionTime(),
            "n1ProductCount", result.getN1ProductCount(),
            "optimizedProductCount", result.getOptimizedProductCount(),
            "performanceImprovement", String.format("%.2f%%", result.getPerformanceImprovement()),
            "description", "N+1 vs Optimized query performance comparison"
        );
        
        logger.info("📊 Performance comparison completed: {}", result);
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 🏥 HEALTH CHECK: Application health and database status
     * 
     * @return Health information
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        return ResponseEntity.ok(Map.of(
            "status", "UP",
            "application", "Catalog N+1 Problem Demo",
            "description", "Spring Boot application demonstrating N+1 query problem and solution",
            "endpoints", Map.of(
                "n1Bug", "/api/v1/products/with-n1-bug",
                "optimized", "/api/v1/products/optimized",
                "comparison", "/api/v1/products/performance-comparison",
                "h2Console", "/h2-console",
                "actuator", "/actuator"
            )
        ));
    }
    
    /**
     * 📈 METRICS: Get current application metrics
     * 
     * @return Current metrics
     */
    @GetMapping("/metrics")
    public ResponseEntity<Map<String, Object>> getMetrics() {
        return ResponseEntity.ok(Map.of(
            "timestamp", System.currentTimeMillis(),
            "availableMetrics", Map.of(
                "catalog.list.products.with.n1.bug", "Timer for N+1 buggy implementation",
                "catalog.list.products.optimized", "Timer for optimized implementation",
                "catalog.products.controller", "Timer for controller operations"
            ),
            "actuatorEndpoints", Map.of(
                "metrics", "/actuator/metrics",
                "prometheus", "/actuator/prometheus",
                "health", "/actuator/health"
            )
        ));
    }
}
