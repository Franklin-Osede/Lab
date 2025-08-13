package com.debugging.catalog.infrastructure.repository;

import com.debugging.catalog.domain.model.Review;
import com.debugging.catalog.domain.repository.ReviewRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * JPA Implementation of Review Repository
 */
@Repository
public interface JpaReviewRepository extends JpaRepository<Review, Long>, ReviewRepository {
    
    /**
     * Find reviews by product ID
     */
    @Override
    @Query("SELECT r FROM Review r WHERE r.product.id = :productId ORDER BY r.createdAt DESC")
    List<Review> findByProductId(@Param("productId") Long productId);
    
    /**
     * Find reviews by rating
     */
    @Override
    @Query("SELECT r FROM Review r WHERE r.rating = :rating ORDER BY r.createdAt DESC")
    List<Review> findByRating(@Param("rating") Integer rating);
    
    /**
     * Find reviews by user name
     */
    @Override
    @Query("SELECT r FROM Review r WHERE r.userName = :userName ORDER BY r.createdAt DESC")
    List<Review> findByUserName(@Param("userName") String userName);
    
    /**
     * Find positive reviews (rating >= 4)
     */
    @Override
    @Query("SELECT r FROM Review r WHERE r.rating >= 4 ORDER BY r.createdAt DESC")
    List<Review> findPositiveReviews();
    
    /**
     * Find negative reviews (rating <= 2)
     */
    @Override
    @Query("SELECT r FROM Review r WHERE r.rating <= 2 ORDER BY r.createdAt DESC")
    List<Review> findNegativeReviews();
    
    /**
     * Count reviews by product ID
     */
    @Override
    @Query("SELECT COUNT(r) FROM Review r WHERE r.product.id = :productId")
    long countByProductId(@Param("productId") Long productId);
    
    /**
     * Get average rating for a product
     */
    @Override
    @Query("SELECT COALESCE(AVG(r.rating), 0.0) FROM Review r WHERE r.product.id = :productId")
    double getAverageRatingByProductId(@Param("productId") Long productId);
    
    /**
     * Get review statistics
     */
    @Query("""
        SELECT 
            COUNT(r) as totalReviews,
            AVG(r.rating) as averageRating,
            COUNT(CASE WHEN r.rating >= 4 THEN 1 END) as positiveReviews,
            COUNT(CASE WHEN r.rating <= 2 THEN 1 END) as negativeReviews
        FROM Review r
        """)
    Object[] getReviewStatistics();
    
    /**
     * Get top rated products
     */
    @Query("""
        SELECT r.product.id, AVG(r.rating) as avgRating, COUNT(r) as reviewCount
        FROM Review r 
        GROUP BY r.product.id 
        HAVING COUNT(r) >= 3
        ORDER BY avgRating DESC, reviewCount DESC
        """)
    List<Object[]> getTopRatedProducts();
}
