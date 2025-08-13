package com.debugging.catalog.application.dto;

import com.debugging.catalog.domain.model.Product;
import com.debugging.catalog.domain.model.Review;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Product Data Transfer Object
 * Used for API responses and application layer communication
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ProductDTO {
    
    private Long id;
    private String name;
    private String description;
    private BigDecimal price;
    private String category;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdAt;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedAt;
    
    private Double averageRating;
    private Integer reviewCount;
    private List<ReviewDTO> reviews;
    
    // Constructor
    public ProductDTO() {}
    
    public ProductDTO(Long id, String name, String description, BigDecimal price, 
                     String category, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.category = category;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Factory methods
    public static ProductDTO from(Product product) {
        ProductDTO dto = new ProductDTO(
            product.getId(),
            product.getName(),
            product.getDescription(),
            product.getPrice(),
            product.getCategory(),
            product.getCreatedAt(),
            product.getUpdatedAt()
        );
        
        dto.setAverageRating(product.getAverageRating());
        dto.setReviewCount(product.getReviewCount());
        
        return dto;
    }
    
    public static ProductDTO from(Product product, List<Review> reviews) {
        ProductDTO dto = from(product);
        
        if (reviews != null && !reviews.isEmpty()) {
            dto.setReviews(reviews.stream()
                .map(ReviewDTO::from)
                .collect(Collectors.toList()));
        }
        
        return dto;
    }
    
    public static ProductDTO fromWithReviews(Product product) {
        ProductDTO dto = from(product);
        
        if (product.hasReviews()) {
            dto.setReviews(product.getReviews().stream()
                .map(ReviewDTO::from)
                .collect(Collectors.toList()));
        }
        
        return dto;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public Double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }
    
    public Integer getReviewCount() {
        return reviewCount;
    }
    
    public void setReviewCount(Integer reviewCount) {
        this.reviewCount = reviewCount;
    }
    
    public List<ReviewDTO> getReviews() {
        return reviews;
    }
    
    public void setReviews(List<ReviewDTO> reviews) {
        this.reviews = reviews;
    }
    
    @Override
    public String toString() {
        return "ProductDTO{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", category='" + category + '\'' +
                ", averageRating=" + averageRating +
                ", reviewCount=" + reviewCount +
                ", reviewsCount=" + (reviews != null ? reviews.size() : 0) +
                '}';
    }
}
