package LHT.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import LHT.dao.impl.ProductDAO;
import LHT.model.Product;
import LHT.service.IProductService;

public class ProductService implements IProductService {

    private final ProductDAO dao = new ProductDAO();

    @Override
    public List<Product> getAllProducts(){
        return dao.getAllProducts();
    }

    @Override
    public Product getProductById(Long productId) {
        return dao.getProductById(productId);
    }

    @Override
    public Long addProduct(Product product) {
        return dao.addProduct(product);
    }

    @Override
    public void updateProduct(Product product) {
        dao.updateProduct(product);
    }

    @Override
    public void deleteProduct(Long productId) {
        dao.deleteProduct(productId);
    }

    @Override
    public List<Product> searchProducts(String keyword) {
        return dao.getAllProducts().stream()
                .filter(p -> p.getProductName().toLowerCase().contains(keyword.toLowerCase()) ||
                           (p.getDescription() != null && p.getDescription().toLowerCase().contains(keyword.toLowerCase())))
                .collect(Collectors.toList());
    }
}