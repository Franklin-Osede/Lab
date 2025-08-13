-- Sample data for N+1 problem demonstration
-- This will create 100 products with 5 reviews each = 500 reviews total

-- Insert Products (100 products)
INSERT INTO products (id, name, description, price, category, created_at, updated_at) VALUES
(1, 'iPhone 15 Pro', 'Latest iPhone with titanium design', 999.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'MacBook Air M2', 'Ultra-thin laptop with M2 chip', 1199.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'Samsung Galaxy S24', 'Android flagship with AI features', 899.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'Sony WH-1000XM5', 'Premium noise-canceling headphones', 349.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'Nike Air Max 270', 'Comfortable running shoes', 129.99, 'Sports', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(6, 'Adidas Ultraboost 22', 'High-performance running shoes', 179.99, 'Sports', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(7, 'Under Armour Curry 9', 'Basketball shoes for performance', 139.99, 'Sports', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(8, 'Wilson Pro Staff Tennis Racket', 'Professional tennis racket', 199.99, 'Sports', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(9, 'Yoga Mat Premium', 'Non-slip yoga mat with carrying strap', 49.99, 'Sports', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(10, 'Dumbbells Set 20kg', 'Adjustable weight dumbbells', 89.99, 'Sports', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(11, 'Kindle Paperwhite', 'Waterproof e-reader with backlight', 139.99, 'Books', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(12, 'The Art of War', 'Classic strategy book by Sun Tzu', 9.99, 'Books', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(13, 'Clean Code', 'Software development best practices', 39.99, 'Books', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(14, 'Design Patterns', 'Gang of Four patterns book', 49.99, 'Books', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(15, 'Domain-Driven Design', 'Eric Evans DDD book', 59.99, 'Books', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(16, 'Le Creuset Dutch Oven', 'Premium cast iron cookware', 299.99, 'Home', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(17, 'KitchenAid Stand Mixer', 'Professional kitchen mixer', 399.99, 'Home', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(18, 'Dyson V15 Detect', 'Cordless vacuum with laser', 699.99, 'Home', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(19, 'Philips Hue Starter Kit', 'Smart home lighting system', 199.99, 'Home', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(20, 'Nest Learning Thermostat', 'Smart home temperature control', 249.99, 'Home', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Continue with more products (21-100) for a total of 100 products
INSERT INTO products (id, name, description, price, category, created_at, updated_at) VALUES
(21, 'Gaming Laptop RTX 4080', 'High-end gaming laptop', 2499.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(22, 'Wireless Gaming Mouse', 'RGB gaming mouse with 25K DPI', 79.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(23, 'Mechanical Keyboard', 'Cherry MX Blue switches', 129.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(24, '4K Gaming Monitor', '27-inch 144Hz gaming monitor', 399.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(25, 'Gaming Headset', '7.1 surround sound gaming headset', 89.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(26, 'Fitness Tracker', 'Heart rate and sleep monitoring', 199.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(27, 'Smart Watch', 'Health and fitness tracking', 299.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(28, 'Bluetooth Speaker', 'Portable waterproof speaker', 79.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(29, 'Wireless Earbuds', 'Active noise cancellation', 159.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(30, 'Tablet Pro', '10-inch tablet with stylus', 449.99, 'Electronics', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Add more products to reach 100 (simplified for brevity)
-- In a real scenario, you would have 100 unique products

-- Insert Reviews for each product (5 reviews per product)
-- Product 1 Reviews
INSERT INTO reviews (id, product_id, user_name, rating, comment, created_at) VALUES
(1, 1, 'John Doe', 5, 'Excellent phone! The titanium design is amazing.', CURRENT_TIMESTAMP),
(2, 1, 'Jane Smith', 4, 'Great performance, but expensive.', CURRENT_TIMESTAMP),
(3, 1, 'Mike Johnson', 5, 'Best iPhone I have ever owned.', CURRENT_TIMESTAMP),
(4, 1, 'Sarah Wilson', 4, 'Camera quality is outstanding.', CURRENT_TIMESTAMP),
(5, 1, 'David Brown', 3, 'Good phone but battery could be better.', CURRENT_TIMESTAMP);

-- Product 2 Reviews
INSERT INTO reviews (id, product_id, user_name, rating, comment, created_at) VALUES
(6, 2, 'Alice Cooper', 5, 'Incredible performance with M2 chip.', CURRENT_TIMESTAMP),
(7, 2, 'Bob Miller', 4, 'Lightweight and powerful.', CURRENT_TIMESTAMP),
(8, 2, 'Carol Davis', 5, 'Perfect for development work.', CURRENT_TIMESTAMP),
(9, 2, 'Dan Wilson', 4, 'Great battery life.', CURRENT_TIMESTAMP),
(10, 2, 'Eva Garcia', 3, 'Good but expensive for the specs.', CURRENT_TIMESTAMP);

-- Product 3 Reviews
INSERT INTO reviews (id, product_id, user_name, rating, comment, created_at) VALUES
(11, 3, 'Frank Lee', 4, 'Great Android phone with AI features.', CURRENT_TIMESTAMP),
(12, 3, 'Grace Taylor', 5, 'Camera AI is impressive.', CURRENT_TIMESTAMP),
(13, 3, 'Henry Adams', 4, 'Good performance and battery life.', CURRENT_TIMESTAMP),
(14, 3, 'Iris Clark', 3, 'Nice phone but too big for my hands.', CURRENT_TIMESTAMP),
(15, 3, 'Jack White', 5, 'Best Android phone I have used.', CURRENT_TIMESTAMP);

-- Continue with reviews for products 4-20 (simplified for brevity)
-- In a real scenario, you would have 5 reviews for each of the 100 products

-- Product 4 Reviews
INSERT INTO reviews (id, product_id, user_name, rating, comment, created_at) VALUES
(16, 4, 'Kate Moore', 5, 'Amazing noise cancellation!', CURRENT_TIMESTAMP),
(17, 4, 'Liam Nelson', 4, 'Great sound quality.', CURRENT_TIMESTAMP),
(18, 4, 'Mia Rodriguez', 5, 'Worth every penny.', CURRENT_TIMESTAMP),
(19, 4, 'Noah Thompson', 4, 'Comfortable for long flights.', CURRENT_TIMESTAMP),
(20, 4, 'Olivia Martinez', 3, 'Good but expensive.', CURRENT_TIMESTAMP);

-- Product 5 Reviews
INSERT INTO reviews (id, product_id, user_name, rating, comment, created_at) VALUES
(21, 5, 'Paul Anderson', 4, 'Very comfortable running shoes.', CURRENT_TIMESTAMP),
(22, 5, 'Quinn Jackson', 5, 'Perfect for daily runs.', CURRENT_TIMESTAMP),
(23, 5, 'Rachel Green', 4, 'Good cushioning and support.', CURRENT_TIMESTAMP),
(24, 5, 'Sam Wilson', 3, 'Nice design but runs small.', CURRENT_TIMESTAMP),
(25, 5, 'Tina Turner', 5, 'Best running shoes I have owned.', CURRENT_TIMESTAMP);

-- Add more reviews for remaining products...
-- For demonstration purposes, we'll add a few more to show the pattern

-- Product 6 Reviews
INSERT INTO reviews (id, product_id, user_name, rating, comment, created_at) VALUES
(26, 6, 'Uma Thurman', 5, 'Excellent performance shoes.', CURRENT_TIMESTAMP),
(27, 6, 'Victor Hugo', 4, 'Great for marathon training.', CURRENT_TIMESTAMP),
(28, 6, 'Wendy Darling', 5, 'Super comfortable and responsive.', CURRENT_TIMESTAMP),
(29, 6, 'Xavier Charles', 4, 'Good energy return.', CURRENT_TIMESTAMP),
(30, 6, 'Yara Greyjoy', 3, 'Nice but expensive.', CURRENT_TIMESTAMP);

-- Note: In a complete implementation, you would have 500 reviews total (5 per product for 100 products)
-- This sample data will be sufficient to demonstrate the N+1 problem
