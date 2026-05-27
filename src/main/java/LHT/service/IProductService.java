package LHT.service;

import java.util.List;

import LHT.model.Product;

public interface IProductService {
    List<Product> getAllProducts();
    Product getProductById(Long productId);
    Long addProduct(Product product);
    void updateProduct(Product product);
    void deleteProduct(Long productId);
    List<Product> searchProducts(String keyword);
}
