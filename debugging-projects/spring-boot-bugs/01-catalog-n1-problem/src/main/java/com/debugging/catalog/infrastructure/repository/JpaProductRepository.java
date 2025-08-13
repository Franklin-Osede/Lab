package com.debugging.catalog.infrastructure.repository;

import com.debugging.catalog.domain.model.Product;
import com.debugging.catalog.domain.repository.ProductRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * JPA Implementation of Product Repository
 * 
 * ❌ BUG INTENCIONAL: The default findAll() method will cause N+1 queries
 * when accessing reviews due to lazy loading
 */
@Repository
public interface JpaProductRepository extends JpaRepository<Product, Long>, ProductRepository {
    
    /**
     * ❌ BUGGY IMPLEMENTATION: Default findAll() causes N+1
     * 
     * This method uses the default JPA findAll() which loads products
     * with lazy-loaded reviews. When the reviews are accessed later,
     * it triggers additional queries for each product.
     * 
     * We use a custom method name to avoid conflicts with JpaRepository.findAll()
     */
    @Query("SELECT p FROM Product p")
    List<Product> findAllProducts();
    
    /**
     * ✅ OPTIMIZED IMPLEMENTATION: Single query with JOIN FETCH
     * 
     * This method uses a single optimized query to fetch all products
     * with their reviews, avoiding the N+1 problem.
     */
    @Override
    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.reviews")
    List<Product> findAllWithReviews();
    
    /**
     * ✅ OPTIMIZED: Find by ID with reviews
     */
    @Override
    @Query("SELECT p FROM Product p LEFT JOIN FETCH p.reviews WHERE p.id = :id")
    Optional<Product> findByIdWithReviews(@Param("id") Long id);
    
    /**
     * Find products by category
     */
    @Override
    List<Product> findByCategory(String category);
    
    /**
     * ✅ OPTIMIZED: Find by category with reviews
     */
    @Override
    @Query("SELECT DISTINCT p FROM Product p LEFT JOIN FETCH p.reviews WHERE p.category = :category")
    List<Product> findByCategoryWithReviews(@Param("category") String category);
    
    /**
     * Find products by price range
     */
    @Override
    @Query("SELECT p FROM Product p WHERE p.price BETWEEN :minPrice AND :maxPrice")
    List<Product> findByPriceRange(@Param("minPrice") BigDecimal minPrice, @Param("maxPrice") BigDecimal maxPrice);
    
    /**
     * ✅ OPTIMIZED: Find products with high average rating
     * This uses a subquery to calculate average ratings
     */
    @Override
    @Query("""
        SELECT p FROM Product p 
        WHERE (SELECT AVG(r.rating) FROM Review r WHERE r.product = p) >= :minRating
        """)
    List<Product> findByAverageRatingGreaterThan(@Param("minRating") double minRating);
    
    /**
     * ✅ OPTIMIZED: Find products with high average rating including reviews
     */
    @Query("""
        SELECT DISTINCT p FROM Product p 
        LEFT JOIN FETCH p.reviews 
        WHERE (SELECT AVG(r.rating) FROM Review r WHERE r.product = p) >= :minRating
        """)
    List<Product> findByAverageRatingGreaterThanWithReviews(@Param("minRating") double minRating);
    
    /**
     * Count products by category
     */
    @Query("SELECT COUNT(p) FROM Product p WHERE p.category = :category")
    long countByCategory(@Param("category") String category);
    
    /**
     * Get product statistics
     */
    @Query("""
        SELECT 
            COUNT(p) as totalProducts,
            COUNT(DISTINCT p.category) as totalCategories,
            AVG(p.price) as averagePrice,
            MIN(p.price) as minPrice,
            MAX(p.price) as maxPrice
        FROM Product p
        """)
    Object[] getProductStatistics();
}
