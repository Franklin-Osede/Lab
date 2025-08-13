package com.debugging.catalog.application.usecase;

import com.debugging.catalog.application.dto.ProductDTO;
import com.debugging.catalog.domain.model.Product;
import com.debugging.catalog.domain.model.Review;
import com.debugging.catalog.domain.repository.ProductRepository;
import com.debugging.catalog.domain.repository.ReviewRepository;
import io.micrometer.core.annotation.Timed;
import io.micrometer.core.annotation.Counted;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Use Case: List Products with Reviews
 * 
 * ❌ BUG INTENCIONAL: This implementation causes N+1 query problem
 * - First query: SELECT * FROM products (1 query)
 * - For each product: SELECT * FROM reviews WHERE product_id = ? (N queries)
 * - Total: 1 + N queries = N+1 problem
 */
@Service
@Transactional(readOnly = true)
public class ListProductsUseCase {
    
    private static final Logger logger = LoggerFactory.getLogger(ListProductsUseCase.class);
    
    private final ProductRepository productRepository;
    private final ReviewRepository reviewRepository;
    
    public ListProductsUseCase(ProductRepository productRepository, ReviewRepository reviewRepository) {
        this.productRepository = productRepository;
        this.reviewRepository = reviewRepository;
    }
    
    /**
     * ❌ BUGGY IMPLEMENTATION: Causes N+1 query problem
     * 
     * This method demonstrates the N+1 problem:
     * 1. Fetches all products (1 query)
     * 2. For each product, fetches its reviews (N queries)
     * 3. Total queries = 1 + N
     * 
     * With 100 products, this results in 101 queries!
     */
    @Timed("catalog.list.products.with.n1.bug")
    @Counted("catalog.list.products.with.n1.bug.count")
    public List<ProductDTO> executeWithN1Bug() {
        logger.info("Starting N+1 buggy implementation");
        long startTime = System.currentTimeMillis();
        
        // ❌ BUG: This causes N+1 queries
        List<Product> products = productRepository.findAllProducts(); // 1 query
        logger.info("Found {} products", products.size());
        
        List<ProductDTO> result = products.stream()
            .map(product -> {
                // ❌ BUG: This causes N additional queries
                List<Review> reviews = reviewRepository.findByProductId(product.getId()); // N queries
                logger.debug("Fetched {} reviews for product {}", reviews.size(), product.getId());
                return ProductDTO.from(product, reviews);
            })
            .collect(Collectors.toList());
        
        long executionTime = System.currentTimeMillis() - startTime;
        logger.info("N+1 buggy implementation completed in {}ms for {} products", 
                   executionTime, products.size());
        
        return result;
    }
    
    /**
     * ✅ CORRECT IMPLEMENTATION: Optimized to avoid N+1
     * 
     * This method uses a single optimized query:
     * 1. Fetches all products with reviews in one query
     * 2. Total queries = 1
     */
    @Timed("catalog.list.products.optimized")
    @Counted("catalog.list.products.optimized.count")
    public List<ProductDTO> executeOptimized() {
        logger.info("Starting optimized implementation");
        long startTime = System.currentTimeMillis();
        
        // ✅ CORRECT: Single optimized query
        List<Product> products = productRepository.findAllWithReviews(); // 1 query
        logger.info("Found {} products with reviews", products.size());
        
        List<ProductDTO> result = products.stream()
            .map(ProductDTO::fromWithReviews)
            .collect(Collectors.toList());
        
        long executionTime = System.currentTimeMillis() - startTime;
        logger.info("Optimized implementation completed in {}ms for {} products", 
                   executionTime, products.size());
        
        return result;
    }
    
    /**
     * Compare performance between buggy and optimized implementations
     */
    public PerformanceComparisonResult comparePerformance() {
        logger.info("Starting performance comparison");
        
        // Warm up JVM
        executeWithN1Bug();
        executeOptimized();
        
        // Measure N+1 implementation
        long n1StartTime = System.currentTimeMillis();
        List<ProductDTO> n1Result = executeWithN1Bug();
        long n1ExecutionTime = System.currentTimeMillis() - n1StartTime;
        
        // Measure optimized implementation
        long optimizedStartTime = System.currentTimeMillis();
        List<ProductDTO> optimizedResult = executeOptimized();
        long optimizedExecutionTime = System.currentTimeMillis() - optimizedStartTime;
        
        return new PerformanceComparisonResult(
            n1ExecutionTime,
            optimizedExecutionTime,
            n1Result.size(),
            optimizedResult.size()
        );
    }
    
    /**
     * Performance comparison result
     */
    public static class PerformanceComparisonResult {
        private final long n1ExecutionTime;
        private final long optimizedExecutionTime;
        private final int n1ProductCount;
        private final int optimizedProductCount;
        
        public PerformanceComparisonResult(long n1ExecutionTime, long optimizedExecutionTime, 
                                         int n1ProductCount, int optimizedProductCount) {
            this.n1ExecutionTime = n1ExecutionTime;
            this.optimizedExecutionTime = optimizedExecutionTime;
            this.n1ProductCount = n1ProductCount;
            this.optimizedProductCount = optimizedProductCount;
        }
        
        public long getN1ExecutionTime() {
            return n1ExecutionTime;
        }
        
        public long getOptimizedExecutionTime() {
            return optimizedExecutionTime;
        }
        
        public int getN1ProductCount() {
            return n1ProductCount;
        }
        
        public int getOptimizedProductCount() {
            return optimizedProductCount;
        }
        
        public double getPerformanceImprovement() {
            if (optimizedExecutionTime == 0) return 0;
            return ((double) n1ExecutionTime / optimizedExecutionTime - 1) * 100;
        }
        
        @Override
        public String toString() {
            return String.format(
                "PerformanceComparisonResult{n1ExecutionTime=%dms, optimizedExecutionTime=%dms, " +
                "improvement=%.2f%%, n1ProductCount=%d, optimizedProductCount=%d}",
                n1ExecutionTime, optimizedExecutionTime, getPerformanceImprovement(),
                n1ProductCount, optimizedProductCount
            );
        }
    }
}
