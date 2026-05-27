package LHT.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import LHT.dao.IProductDAO;
import LHT.model.Product;
import LHT.util.DBConnection;

public class ProductDAO implements IProductDAO {

    @Override
    public List<Product> getAllProducts() {
        String sql = "SELECT product_id, product_name, price, stock_quantity, image_url, description FROM products";
        List<Product> products = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                products.add(mapRowToProduct(rs));
            }

        } catch (Exception e) {
            throw new RuntimeException("Error getting all products", e);
        }

        return products;
    }

    @Override
    public Product getProductById(Long productId) {
        String sql = "SELECT product_id, product_name, price, stock_quantity, image_url, description FROM products WHERE product_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRowToProduct(rs);
            }

        } catch (Exception e) {
            throw new RuntimeException("Error getting product", e);
        }

        return null;
    }

    @Override
    public Long addProduct(Product product) {
        String sql = """
            INSERT INTO products(product_name, price, stock_quantity, image_url, description)
            VALUES (?, ?, ?, ?, ?)
            RETURNING product_id
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, product.getProductName());
            ps.setDouble(2, product.getPrice());
            ps.setInt(3, product.getStockQuantity());
            ps.setString(4, product.getImageUrl());
            ps.setString(5, product.getDescription());

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getLong(1);
            }

        } catch (Exception e) {
            throw new RuntimeException("Error adding product", e);
        }

        return null;
    }

    @Override
    public void updateProduct(Product product) {
        String sql = """
            UPDATE products 
            SET product_name = ?, price = ?, stock_quantity = ?, image_url = ?, description = ?
            WHERE product_id = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, product.getProductName());
            ps.setDouble(2, product.getPrice());
            ps.setInt(3, product.getStockQuantity());
            ps.setString(4, product.getImageUrl());
            ps.setString(5, product.getDescription());
            ps.setLong(6, product.getProductId());

            ps.executeUpdate();
            System.out.println("Product " + product.getProductId() + " updated");

        } catch (Exception e) {
            throw new RuntimeException("Error updating product", e);
        }
    }

    @Override
    public void deleteProduct(Long productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            ps.executeUpdate();
            System.out.println("Product " + productId + " deleted");

        } catch (Exception e) {
            throw new RuntimeException("Error deleting product", e);
        }
    }

    @Override
    public List<Product> getProductsByCategory(String category) {
        // Implement based on your database schema if you have categories
        return getAllProducts();
    }

    private Product mapRowToProduct(ResultSet rs) throws SQLException {
        return new Product(
            rs.getLong("product_id"),
            rs.getString("product_name"),
            rs.getDouble("price"),
            rs.getInt("stock_quantity"),
            rs.getString("image_url"),
            rs.getString("description")
        );
    }
}
