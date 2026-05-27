package LHT.dao.impl;

import LHT.dao.ICartDAO;
import LHT.model.CartItem;
import LHT.model.Product;
import LHT.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class CartDAO implements ICartDAO{
	public void createCart(Long customerId) {

		String sql = """
				    INSERT INTO shopping_cart(customer_id)
				    VALUES (?)
				""";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setLong(1, customerId);

			int rows = ps.executeUpdate();
			System.out.println("createCart rows = " + rows);

		} catch (Exception e) {
			throw new RuntimeException("CREATE CART FAILED for customerId=" + customerId, e);
		}
	}

	@Override
	public void addToCart(Long customerId, Long productId) {

	    String findCartSql = """
	        SELECT shopping_cart_id
	        FROM shopping_cart
	        WHERE customer_id = ?
	    """;

	    String checkItemSql = """
	        SELECT cart_item_id, quantity
	        FROM cart_item
	        WHERE shopping_cart_id = ?
	        AND product_id = ?
	    """;

	    String updateQtySql = """
	        UPDATE cart_item
	        SET quantity = quantity + 1
	        WHERE cart_item_id = ?
	    """;

	    String insertItemSql = """
	        INSERT INTO cart_item(
	            shopping_cart_id,
	            product_id,
	            quantity
	        )
	        VALUES (?, ?, ?)
	    """;

	    try (
	            Connection conn = DBConnection.getConnection();
	            PreparedStatement cartStmt =
	                    conn.prepareStatement(findCartSql)
	    ) {

	        cartStmt.setLong(1, customerId);

	        ResultSet cartRs = cartStmt.executeQuery();

	        Long cartId = null;

	        if (cartRs.next()) {
	            cartId = cartRs.getLong("shopping_cart_id");
	        }

	        if (cartId == null) {
	            throw new RuntimeException("Shopping cart not found");
	        }

	        // check existing product
	        try (
	                PreparedStatement checkStmt =
	                        conn.prepareStatement(checkItemSql)
	        ) {

	            checkStmt.setLong(1, cartId);
	            checkStmt.setLong(2, productId);

	            ResultSet rs = checkStmt.executeQuery();

	            // product already exists
	            if (rs.next()) {

	                Long cartItemId =
	                        rs.getLong("cart_item_id");

	                try (
	                        PreparedStatement updateStmt =
	                                conn.prepareStatement(updateQtySql)
	                ) {

	                    updateStmt.setLong(1, cartItemId);

	                    updateStmt.executeUpdate();

	                    System.out.println(
	                            "DEBUG: quantity updated"
	                    );
	                }

	            } else {

	                // insert new item
	                try (
	                        PreparedStatement insertStmt =
	                                conn.prepareStatement(insertItemSql)
	                ) {

	                    insertStmt.setLong(1, cartId);
	                    insertStmt.setLong(2, productId);
	                    insertStmt.setInt(3, 1);

	                    insertStmt.executeUpdate();

	                    System.out.println(
	                            "DEBUG: new cart item inserted"
	                    );
	                }
	            }
	        }

	    } catch (Exception e) {
	        throw new RuntimeException(e);
	    }
	}

	public Long getCartId(Long customerId) {
		String sql = "SELECT shopping_cart_id FROM shopping_cart WHERE customer_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setLong(1, customerId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return rs.getLong("shopping_cart_id");
			}

		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		return null;
	}

	public int getCartCount(Long customerId) {

		String sql = """
				    SELECT COALESCE(SUM(quantity), 0) AS total
				    FROM cart_item ci
				    JOIN shopping_cart sc ON ci.shopping_cart_id = sc.shopping_cart_id
				    WHERE sc.customer_id = ?
				""";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setLong(1, customerId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return rs.getInt("total");
			}

		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		return 0;
	}

	public List<CartItem> getCartItems(Long customerId) {

		String sql = """
				    SELECT
				        ci.cart_item_id,
				        ci.quantity,
				        p.product_id,
				        p.product_name,
				        p.price
				    FROM cart_item ci
				    JOIN shopping_cart sc ON ci.shopping_cart_id = sc.shopping_cart_id
				    JOIN products p ON ci.product_id = p.product_id
				    WHERE sc.customer_id = ?
				""";

		List<CartItem> items = new java.util.ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setLong(1, customerId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Product p = new Product();
				p.setProductId(rs.getLong("product_id"));
				p.setProductName(rs.getString("product_name"));
				p.setPrice(rs.getDouble("price"));

				CartItem item = new CartItem();
				item.setCartItemId(rs.getLong("cart_item_id"));
				item.setProduct(p);
				item.setQuantity(rs.getInt("quantity"));

				items.add(item);
			}

		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		return items;
	}

	@Override
	public double getTotalPrice(Long customerId) {

	    double subtotal = 0.0;

	    String sql = """
	        SELECT
	            p.price,
	            ci.quantity
	        FROM cart_item ci
	        JOIN shopping_cart sc ON ci.shopping_cart_id = sc.shopping_cart_id
	        JOIN products p ON ci.product_id = p.product_id
	        WHERE sc.customer_id = ?
	    """;

	    try (
	        Connection conn = DBConnection.getConnection();
	        PreparedStatement ps = conn.prepareStatement(sql)
	    ) {

	        ps.setLong(1, customerId);

	        try (ResultSet rs = ps.executeQuery()) {

	            while (rs.next()) {

	                double price = rs.getDouble("price");
	                int quantity = rs.getInt("quantity");

	                subtotal += (price * quantity);

	                System.out.println(
	                    "DEBUG => price="
	                    + price
	                    + ", qty="
	                    + quantity
	                    + ", subtotal="
	                    + subtotal
	                );
	            }
	        }

	    } catch (Exception e) {
	        // propagate the exception so callers can rollback instead of treating it as zero
	        throw new RuntimeException("Failed to compute cart total for customerId=" + customerId, e);
	    }

	    return subtotal;
	}

	public void updateQuantity(Long cartItemId, int quantity) {

		String sql = """
				    UPDATE cart_item
				    SET quantity = ?
				    WHERE cart_item_id = ?
				""";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, quantity);
			ps.setLong(2, cartItemId);

			ps.executeUpdate();

		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	public void removeItem(Long cartItemId) {

		String sql = "DELETE FROM cart_item WHERE cart_item_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setLong(1, cartItemId);
			ps.executeUpdate();

		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	@Override
	public void clearCart(Long customerId) {
		// TODO Auto-generated method stub
		
	}
}