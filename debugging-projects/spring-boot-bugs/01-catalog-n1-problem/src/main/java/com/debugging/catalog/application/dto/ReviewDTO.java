package com.debugging.catalog.application.dto;

import com.debugging.catalog.domain.model.Review;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.time.LocalDateTime;

/**
 * Review Data Transfer Object
 * Used for API responses and application layer communication
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ReviewDTO {
    
    private Long id;
    private String userName;
    private Integer rating;
    private String comment;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;
    
    private String ratingDescription;
    private Boolean isPositive;
    private Boolean isNegative;
    
    // Constructor
    public ReviewDTO() {}
    
    public ReviewDTO(Long id, String userName, Integer rating, String comment, LocalDateTime createdAt) {
        this.id = id;
        this.userName = userName;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
        this.ratingDescription = getRatingDescription(rating);
        this.isPositive = rating >= 4;
        this.isNegative = rating <= 2;
    }
    
    // Factory method
    public static ReviewDTO from(Review review) {
        return new ReviewDTO(
            review.getId(),
            review.getUserName(),
            review.getRating(),
            review.getComment(),
            review.getCreatedAt()
        );
    }
    
    private String getRatingDescription(Integer rating) {
        return switch (rating) {
            case 1 -> "Very Poor";
            case 2 -> "Poor";
            case 3 -> "Average";
            case 4 -> "Good";
            case 5 -> "Excellent";
            default -> "Unknown";
        };
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public Integer getRating() {
        return rating;
    }
    
    public void setRating(Integer rating) {
        this.rating = rating;
        this.ratingDescription = getRatingDescription(rating);
        this.isPositive = rating >= 4;
        this.isNegative = rating <= 2;
    }
    
    public String getComment() {
        return comment;
    }
    
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getRatingDescription() {
        return ratingDescription;
    }
    
    public void setRatingDescription(String ratingDescription) {
        this.ratingDescription = ratingDescription;
    }
    
    public Boolean getIsPositive() {
        return isPositive;
    }
    
    public void setIsPositive(Boolean isPositive) {
        this.isPositive = isPositive;
    }
    
    public Boolean getIsNegative() {
        return isNegative;
    }
    
    public void setIsNegative(Boolean isNegative) {
        this.isNegative = isNegative;
    }
    
    @Override
    public String toString() {
        return "ReviewDTO{" +
                "id=" + id +
                ", userName='" + userName + '\'' +
                ", rating=" + rating +
                ", ratingDescription='" + ratingDescription + '\'' +
                ", comment='" + (comment != null ? comment.substring(0, Math.min(comment.length(), 30)) + "..." : null) + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
