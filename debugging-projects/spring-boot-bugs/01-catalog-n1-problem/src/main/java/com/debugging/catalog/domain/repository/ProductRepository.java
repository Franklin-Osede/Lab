package com.debugging.catalog.domain.repository;

import com.debugging.catalog.domain.model.Product;
import java.util.List;
import java.util.Optional;

/**
 * Product Repository Interface
 * Defines contract for product persistence operations
 */
public interface ProductRepository {
    
    /**
     * Find all products (causes N+1 queries)
     * Note: This method causes N+1 queries when accessing lazy-loaded reviews.
     * Use findAllWithReviews() for optimized queries.
     * @return List of all products
     */
    List<Product> findAllProducts();
    
    /**
     * Find all products with their reviews loaded
     * This method should be optimized to avoid N+1 queries
     * @return List of products with reviews
     */
    List<Product> findAllWithReviews();
    
    /**
     * Find product by ID
     * @param id Product ID
     * @return Optional containing product if found
     */
    Optional<Product> findById(Long id);
    
    /**
     * Find product by ID with reviews loaded
     * @param id Product ID
     * @return Optional containing product with reviews if found
     */
    Optional<Product> findByIdWithReviews(Long id);
    
    /**
     * Find products by category
     * @param category Product category
     * @return List of products in the category
     */
    List<Product> findByCategory(String category);
    
    /**
     * Find products by category with reviews
     * @param category Product category
     * @return List of products in the category with reviews
     */
    List<Product> findByCategoryWithReviews(String category);
    
    /**
     * Find products by price range
     * @param minPrice Minimum price
     * @param maxPrice Maximum price
     * @return List of products in price range
     */
    List<Product> findByPriceRange(java.math.BigDecimal minPrice, java.math.BigDecimal maxPrice);
    
    /**
     * Save product
     * @param product Product to save
     * @return Saved product
     */
    Product save(Product product);
    
    /**
     * Delete product by ID
     * @param id Product ID to delete
     */
    void deleteById(Long id);
    
    /**
     * Check if product exists by ID
     * @param id Product ID
     * @return true if product exists
     */
    boolean existsById(Long id);
    
    /**
     * Count total products
     * @return Total number of products
     */
    long count();
    
    /**
     * Find products with average rating above threshold
     * @param minRating Minimum average rating (1-5)
     * @return List of products with high ratings
     */
    List<Product> findByAverageRatingGreaterThan(double minRating);
}
