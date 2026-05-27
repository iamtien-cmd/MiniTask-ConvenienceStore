package LHT.dao;

import java.util.List;

import LHT.model.Product;

public interface IProductDAO {
    /**
     * Get all products
     */
    List<Product> getAllProducts();
    
    /**
     * Get product by ID
     */
    Product getProductById(Long productId);
    
    /**
     * Add new product
     */
    Long addProduct(Product product);
    
    /**
     * Update product
     */
    void updateProduct(Product product);
    
    /**
     * Delete product
     */
    void deleteProduct(Long productId);
    
    /**
     * Get products by category
     */
    List<Product> getProductsByCategory(String category);
}
