package com.debugging.catalog.domain.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 * Product Aggregate Root
 * Contains business logic for product management
 */
@Entity
@Table(name = "products")
public class Product {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 255)
    private String name;
    
    @Column(length = 1000)
    private String description;
    
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;
    
    @Column(length = 100)
    private String category;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    // ❌ BUG INTENCIONAL: Lazy loading por defecto causará N+1
    @OneToMany(mappedBy = "product", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Review> reviews = new ArrayList<>();
    
    // Constructor for JPA
    protected Product() {}
    
    // Constructor for domain logic
    public Product(String name, String description, BigDecimal price, String category) {
        this.name = Objects.requireNonNull(name, "Product name cannot be null");
        this.description = description;
        this.price = Objects.requireNonNull(price, "Product price cannot be null");
        this.category = category;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    // Domain methods
    public void addReview(Review review) {
        Objects.requireNonNull(review, "Review cannot be null");
        reviews.add(review);
        review.setProduct(this);
        this.updatedAt = LocalDateTime.now();
    }
    
    public void removeReview(Review review) {
        if (reviews.remove(review)) {
            review.setProduct(null);
            this.updatedAt = LocalDateTime.now();
        }
    }
    
    public double getAverageRating() {
        if (reviews.isEmpty()) {
            return 0.0;
        }
        return reviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);
    }
    
    public int getReviewCount() {
        return reviews.size();
    }
    
    public boolean hasReviews() {
        return !reviews.isEmpty();
    }
    
    public void updatePrice(BigDecimal newPrice) {
        this.price = Objects.requireNonNull(newPrice, "Price cannot be null");
        this.updatedAt = LocalDateTime.now();
    }
    
    public void updateDetails(String name, String description, String category) {
        if (name != null && !name.trim().isEmpty()) {
            this.name = name;
        }
        this.description = description;
        this.category = category;
        this.updatedAt = LocalDateTime.now();
    }
    
    // Getters
    public Long getId() {
        return id;
    }
    
    public String getName() {
        return name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public String getCategory() {
        return category;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public List<Review> getReviews() {
        return Collections.unmodifiableList(reviews);
    }
    
    // Equals and HashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Product product = (Product) o;
        return Objects.equals(id, product.id);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
    
    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", category='" + category + '\'' +
                ", reviewCount=" + getReviewCount() +
                ", averageRating=" + getAverageRating() +
                '}';
    }
}
