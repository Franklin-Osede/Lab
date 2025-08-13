package com.debugging.catalog.application.usecase;

import com.debugging.catalog.application.dto.ProductDTO;
import com.debugging.catalog.domain.model.Product;
import com.debugging.catalog.domain.model.Review;
import com.debugging.catalog.domain.repository.ProductRepository;
import com.debugging.catalog.domain.repository.ReviewRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

/**
 * Unit tests for ListProductsUseCase
 * Tests both N+1 buggy implementation and optimized solution
 */
@ExtendWith(MockitoExtension.class)
class ListProductsUseCaseTest {
    
    @Mock
    private ProductRepository productRepository;
    
    @Mock
    private ReviewRepository reviewRepository;
    
    private ListProductsUseCase useCase;
    
    @BeforeEach
    void setUp() {
        useCase = new ListProductsUseCase(productRepository, reviewRepository);
    }
    
    @Test
    void executeWithN1Bug_ShouldReturnProductsWithReviews() {
        // Given
        Product product1 = createProduct(1L, "iPhone 15", "Latest iPhone", BigDecimal.valueOf(999.99));
        Product product2 = createProduct(2L, "MacBook Air", "Ultra-thin laptop", BigDecimal.valueOf(1199.99));
        
        List<Review> reviews1 = Arrays.asList(
            createReview(1L, "John Doe", 5, "Excellent phone!"),
            createReview(2L, "Jane Smith", 4, "Great performance")
        );
        
        List<Review> reviews2 = Arrays.asList(
            createReview(3L, "Bob Wilson", 5, "Perfect for development")
        );
        
        when(productRepository.findAllProducts()).thenReturn(Arrays.asList(product1, product2));
        when(reviewRepository.findByProductId(1L)).thenReturn(reviews1);
        when(reviewRepository.findByProductId(2L)).thenReturn(reviews2);
        
        // When
        List<ProductDTO> result = useCase.executeWithN1Bug();
        
        // Then
        assertThat(result).hasSize(2);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        assertThat(result.get(0).getName()).isEqualTo("iPhone 15");
        assertThat(result.get(0).getReviews()).hasSize(2);
        assertThat(result.get(1).getId()).isEqualTo(2L);
        assertThat(result.get(1).getName()).isEqualTo("MacBook Air");
        assertThat(result.get(1).getReviews()).hasSize(1);
        
        // Verify N+1 behavior: 1 call to findAllProducts + 2 calls to findByProductId
        verify(productRepository, times(1)).findAllProducts();
        verify(reviewRepository, times(2)).findByProductId(anyLong());
    }
    
    @Test
    void executeOptimized_ShouldReturnProductsWithReviews() {
        // Given
        Product product1 = createProductWithReviews(1L, "iPhone 15", "Latest iPhone", BigDecimal.valueOf(999.99));
        Product product2 = createProductWithReviews(2L, "MacBook Air", "Ultra-thin laptop", BigDecimal.valueOf(1199.99));
        
        when(productRepository.findAllWithReviews()).thenReturn(Arrays.asList(product1, product2));
        
        // When
        List<ProductDTO> result = useCase.executeOptimized();
        
        // Then
        assertThat(result).hasSize(2);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        assertThat(result.get(0).getName()).isEqualTo("iPhone 15");
        assertThat(result.get(0).getReviews()).hasSize(2);
        assertThat(result.get(1).getId()).isEqualTo(2L);
        assertThat(result.get(1).getName()).isEqualTo("MacBook Air");
        assertThat(result.get(1).getReviews()).hasSize(1);
        
        // Verify optimized behavior: only 1 call to findAllWithReviews
        verify(productRepository, times(1)).findAllWithReviews();
        verify(reviewRepository, never()).findByProductId(anyLong());
    }
    
    @Test
    void comparePerformance_ShouldReturnComparisonResult() {
        // Given
        Product product1 = createProductWithReviews(1L, "iPhone 15", "Latest iPhone", BigDecimal.valueOf(999.99));
        Product product2 = createProductWithReviews(2L, "MacBook Air", "Ultra-thin laptop", BigDecimal.valueOf(1199.99));
        
        when(productRepository.findAllProducts()).thenReturn(Arrays.asList(product1, product2));
        when(productRepository.findAllWithReviews()).thenReturn(Arrays.asList(product1, product2));
        when(reviewRepository.findByProductId(anyLong())).thenReturn(Arrays.asList(createReview(1L, "User", 5, "Great")));
        
        // When
        ListProductsUseCase.PerformanceComparisonResult result = useCase.comparePerformance();
        
        // Then
        assertThat(result).isNotNull();
        assertThat(result.getN1ProductCount()).isEqualTo(2);
        assertThat(result.getOptimizedProductCount()).isEqualTo(2);
        assertThat(result.getN1ExecutionTime()).isGreaterThan(0);
        assertThat(result.getOptimizedExecutionTime()).isGreaterThan(0);
        assertThat(result.getPerformanceImprovement()).isGreaterThan(0);
    }
    
    @Test
    void executeWithN1Bug_WithNoProducts_ShouldReturnEmptyList() {
        // Given
        when(productRepository.findAllProducts()).thenReturn(Arrays.asList());
        
        // When
        List<ProductDTO> result = useCase.executeWithN1Bug();
        
        // Then
        assertThat(result).isEmpty();
        verify(productRepository, times(1)).findAllProducts();
        verify(reviewRepository, never()).findByProductId(anyLong());
    }
    
    @Test
    void executeOptimized_WithNoProducts_ShouldReturnEmptyList() {
        // Given
        when(productRepository.findAllWithReviews()).thenReturn(Arrays.asList());
        
        // When
        List<ProductDTO> result = useCase.executeOptimized();
        
        // Then
        assertThat(result).isEmpty();
        verify(productRepository, times(1)).findAllWithReviews();
        verify(reviewRepository, never()).findByProductId(anyLong());
    }
    
    // Helper methods
    private Product createProduct(Long id, String name, String description, BigDecimal price) {
        Product product = new Product(name, description, price, "Electronics");
        // Use reflection to set ID for testing
        try {
            java.lang.reflect.Field idField = Product.class.getDeclaredField("id");
            idField.setAccessible(true);
            idField.set(product, id);
        } catch (Exception e) {
            throw new RuntimeException("Failed to set product ID", e);
        }
        return product;
    }
    
    private Product createProductWithReviews(Long id, String name, String description, BigDecimal price) {
        Product product = createProduct(id, name, description, price);
        
        Review review1 = createReview(1L, "User1", 5, "Great product");
        Review review2 = createReview(2L, "User2", 4, "Good product");
        
        product.addReview(review1);
        product.addReview(review2);
        
        return product;
    }
    
    private Review createReview(Long id, String userName, Integer rating, String comment) {
        Review review = new Review(userName, rating, comment);
        // Use reflection to set ID for testing
        try {
            java.lang.reflect.Field idField = Review.class.getDeclaredField("id");
            idField.setAccessible(true);
            idField.set(review, id);
        } catch (Exception e) {
            throw new RuntimeException("Failed to set review ID", e);
        }
        return review;
    }
}
