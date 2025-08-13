package com.debugging.catalog.domain.repository;

import com.debugging.catalog.domain.model.Review;
import java.util.List;
import java.util.Optional;

/**
 * Review Repository Interface
 * Defines contract for review persistence operations
 */
public interface ReviewRepository {
    
    /**
     * Find all reviews
     * @return List of all reviews
     */
    List<Review> findAll();
    
    /**
     * Find reviews by product ID
     * @param productId Product ID
     * @return List of reviews for the product
     */
    List<Review> findByProductId(Long productId);
    
    /**
     * Find review by ID
     * @param id Review ID
     * @return Optional containing review if found
     */
    Optional<Review> findById(Long id);
    
    /**
     * Find reviews by rating
     * @param rating Review rating (1-5)
     * @return List of reviews with the specified rating
     */
    List<Review> findByRating(Integer rating);
    
    /**
     * Find reviews by user name
     * @param userName User name
     * @return List of reviews by the user
     */
    List<Review> findByUserName(String userName);
    
    /**
     * Find positive reviews (rating >= 4)
     * @return List of positive reviews
     */
    List<Review> findPositiveReviews();
    
    /**
     * Find negative reviews (rating <= 2)
     * @return List of negative reviews
     */
    List<Review> findNegativeReviews();
    
    /**
     * Save review
     * @param review Review to save
     * @return Saved review
     */
    Review save(Review review);
    
    /**
     * Delete review by ID
     * @param id Review ID to delete
     */
    void deleteById(Long id);
    
    /**
     * Check if review exists by ID
     * @param id Review ID
     * @return true if review exists
     */
    boolean existsById(Long id);
    
    /**
     * Count total reviews
     * @return Total number of reviews
     */
    long count();
    
    /**
     * Count reviews by product ID
     * @param productId Product ID
     * @return Number of reviews for the product
     */
    long countByProductId(Long productId);
    
    /**
     * Get average rating for a product
     * @param productId Product ID
     * @return Average rating or 0.0 if no reviews
     */
    double getAverageRatingByProductId(Long productId);
}
