package com.debugging.catalog.domain.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Review Entity - Part of Product Aggregate
 * Contains review information and business logic
 */
@Entity
@Table(name = "reviews")
public class Review {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;
    
    @Column(name = "user_name", nullable = false, length = 255)
    private String userName;
    
    @Column(nullable = false)
    private Integer rating;
    
    @Column(length = 1000)
    private String comment;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    // Constructor for JPA
    protected Review() {}
    
    // Constructor for domain logic
    public Review(String userName, Integer rating, String comment) {
        this.userName = Objects.requireNonNull(userName, "User name cannot be null");
        this.rating = validateRating(rating);
        this.comment = comment;
        this.createdAt = LocalDateTime.now();
    }
    
    // Domain methods
    private Integer validateRating(Integer rating) {
        if (rating == null || rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
        return rating;
    }
    
    public void updateRating(Integer newRating) {
        this.rating = validateRating(newRating);
    }
    
    public void updateComment(String newComment) {
        this.comment = newComment;
    }
    
    public boolean isPositiveReview() {
        return rating >= 4;
    }
    
    public boolean isNegativeReview() {
        return rating <= 2;
    }
    
    public String getRatingDescription() {
        return switch (rating) {
            case 1 -> "Very Poor";
            case 2 -> "Poor";
            case 3 -> "Average";
            case 4 -> "Good";
            case 5 -> "Excellent";
            default -> "Unknown";
        };
    }
    
    // Getters
    public Long getId() {
        return id;
    }
    
    public Product getProduct() {
        return product;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public Integer getRating() {
        return rating;
    }
    
    public String getComment() {
        return comment;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    // Setter for JPA relationship
    void setProduct(Product product) {
        this.product = product;
    }
    
    // Equals and HashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Review review = (Review) o;
        return Objects.equals(id, review.id);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
    
    @Override
    public String toString() {
        return "Review{" +
                "id=" + id +
                ", userName='" + userName + '\'' +
                ", rating=" + rating +
                ", comment='" + (comment != null ? comment.substring(0, Math.min(comment.length(), 50)) + "..." : null) + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
