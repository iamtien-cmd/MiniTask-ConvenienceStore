package LHT.dao.impl;

import LHT.dao.IOrderDAO;
import LHT.model.Order;
import LHT.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public class OrderDAO implements IOrderDAO {

    @Override
    public Long createOrder(Long customerId,
                            String status,
                            String paymentMethod,
                            String recipientName,
                            String phoneNumber,
                            String deliveryAddress) {
        // legacy signature remains for compatibility; real selection filtering is handled at service layer

        String cartTotalSql = """
            SELECT COALESCE(SUM(p.price * ci.quantity), 0)
            FROM cart_item ci
            JOIN shopping_cart sc
                ON ci.shopping_cart_id = sc.shopping_cart_id
            JOIN products p
                ON ci.product_id = p.product_id
            WHERE sc.customer_id = ?
        """;

        String insertOrderSql = """
            INSERT INTO orders (
                customer_id,
                order_date,
                total_amount,
                status,
                payment_method,
                recipient_name,
                phone_number,
                delivery_address
            )
            VALUES (?, NOW(), ?, ?, ?, ?, ?, ?)
            RETURNING order_id
        """;

        String cartItemsSql = """
            SELECT
                p.product_id,
                p.price,
                ci.quantity
            FROM cart_item ci
            JOIN shopping_cart sc
                ON ci.shopping_cart_id = sc.shopping_cart_id
            JOIN products p
                ON ci.product_id = p.product_id
            WHERE sc.customer_id = ?
        """;

        String insertOrderLineSql = """
            INSERT INTO order_line (
                order_id,
                product_id,
                quantity,
                unit_price,
                total_price
            )
            VALUES (?, ?, ?, ?, ?)
        """;

        try (
                Connection conn = DBConnection.getConnection()
        ) {

            conn.setAutoCommit(false);

            double cartTotal = 0;

            // Get cart total
            try (
                    PreparedStatement ps = conn.prepareStatement(cartTotalSql)
            ) {

                ps.setLong(1, customerId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        cartTotal = rs.getDouble(1);
                    }
                }
            }

            Long orderId = null;

            // Create order
            try (
                    PreparedStatement ps = conn.prepareStatement(insertOrderSql)
            ) {

                ps.setLong(1, customerId);
                ps.setDouble(2, cartTotal);
                ps.setString(3, status);
                ps.setString(4, paymentMethod);
                ps.setString(5, recipientName);
                ps.setString(6, phoneNumber);
                ps.setString(7, deliveryAddress);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        orderId = rs.getLong("order_id");
                    }
                }
            }

            if (orderId == null) {
                conn.rollback();
                return null;
            }

            // Copy cart items -> order_line
            try (PreparedStatement ps = conn.prepareStatement(cartItemsSql)) {

                ps.setLong(1, customerId);

                // detect which columns exist in order_line and adapt INSERT
                Set<String> lineCols = new java.util.HashSet<>();
                String colSql = "SELECT column_name FROM information_schema.columns WHERE table_schema='public' AND table_name = 'order_line'";
                try (PreparedStatement colPs = conn.prepareStatement(colSql);
                     ResultSet crs = colPs.executeQuery()) {
                    while (crs.next()) {
                        lineCols.add(crs.getString(1).toLowerCase());
                    }
                } catch (Exception ignore) {
                    // table might not exist or be named differently; keep lineCols empty
                }

                // choose line total column name if present
                String lineTotalCol = null;
                if (lineCols.contains("total_price")) lineTotalCol = "total_price";
                else if (lineCols.contains("line_total")) lineTotalCol = "line_total";
                else if (lineCols.contains("total")) lineTotalCol = "total";

                // build insert SQL dynamically
                StringBuilder insCols = new StringBuilder();
                StringBuilder insVals = new StringBuilder();
                java.util.List<String> colsOrder = new java.util.ArrayList<>();

                insCols.append("order_id, product_id, quantity, unit_price");
                insVals.append("?, ?, ?, ?");
                colsOrder.add("order_id"); colsOrder.add("product_id"); colsOrder.add("quantity"); colsOrder.add("unit_price");

                if (lineTotalCol != null) {
                    insCols.append(", ").append(lineTotalCol);
                    insVals.append(", ?");
                    colsOrder.add(lineTotalCol);
                }

                String dynamicInsert = String.format("INSERT INTO order_line (%s) VALUES (%s)", insCols.toString(), insVals.toString());

                try (ResultSet rs = ps.executeQuery()) {
                     while (rs.next()) {
                        long productId = rs.getLong("product_id");
                        double unitPrice = rs.getDouble("price");
                        int quantity = rs.getInt("quantity");

                        double totalPrice = unitPrice * quantity;

                        // check if we already added this product for this order (avoid duplicates)
                        boolean alreadyInserted = false;
                        String checkSql = "SELECT 1 FROM order_line WHERE order_id = ? AND product_id = ? LIMIT 1";
                        try (PreparedStatement cps = conn.prepareStatement(checkSql)) {
                            cps.setLong(1, orderId);
                            cps.setLong(2, productId);
                            try (ResultSet cr = cps.executeQuery()) {
                                if (cr.next()) alreadyInserted = true;
                            }
                        } catch (Exception ignore) {}

                        if (alreadyInserted) {
                            // update existing line quantity (sum quantities)
                            String updSql = "UPDATE order_line SET quantity = quantity + ?, unit_price = ? WHERE order_id = ? AND product_id = ?";
                            try (PreparedStatement ups = conn.prepareStatement(updSql)) {
                                ups.setInt(1, quantity);
                                ups.setDouble(2, unitPrice);
                                ups.setLong(3, orderId);
                                ups.setLong(4, productId);
                                ups.executeUpdate();
                            } catch (Exception ex) {
                                // fallback: ignore
                            }
                        } else {
                            try (PreparedStatement ips = conn.prepareStatement(dynamicInsert)) {
                                int idx = 1;
                                ips.setLong(idx++, orderId);
                                ips.setLong(idx++, productId);
                                ips.setInt(idx++, quantity);
                                ips.setDouble(idx++, unitPrice);
                                if (lineTotalCol != null) {
                                    ips.setDouble(idx++, totalPrice);
                                }
                                ips.executeUpdate();
                            } catch (SQLException e) {
                                // fallback: try inserting without total column
                                try (PreparedStatement ips2 = conn.prepareStatement("INSERT INTO order_line (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)") ) {
                                    ips2.setLong(1, orderId);
                                    ips2.setLong(2, productId);
                                    ips2.setInt(3, quantity);
                                    ips2.setDouble(4, unitPrice);
                                    ips2.executeUpdate();
                                } catch (Exception ex2) {
                                    throw ex2;
                                }
                            }
                        }
                    }
                }
            }

            // Clear cart
            String clearCartSql = """
                DELETE FROM cart_item
                WHERE shopping_cart_id IN (
                    SELECT shopping_cart_id
                    FROM shopping_cart
                    WHERE customer_id = ?
                )
            """;

            try (
                    PreparedStatement ps =
                            conn.prepareStatement(clearCartSql)
            ) {

                ps.setLong(1, customerId);
                ps.executeUpdate();
            }

            // Recompute total from order_line (ensure orders.total_amount matches inserted lines)
            // Recompute total from order_line
            try {
                String sumSql = "SELECT COALESCE(SUM(COALESCE(unit_price,0) * COALESCE(quantity,0)), 0) FROM order_line WHERE order_id = ?";

                try (PreparedStatement sps = conn.prepareStatement(sumSql)) {

                    sps.setLong(1, orderId);

                    try (ResultSet srs = sps.executeQuery()) {

                        if (srs.next()) {

                            double computed = srs.getDouble(1);

                            String upd = """
                                UPDATE orders
                                SET total_amount = ?
                                WHERE order_id = ?
                            """;

                            try (PreparedStatement ups = conn.prepareStatement(upd)) {

                                ups.setDouble(1, computed);
                                ups.setLong(2, orderId);

                                int ru = ups.executeUpdate();

                                System.out.println(
                                    "DEBUG: recomputed order total rows="
                                    + ru
                                    + " computed="
                                    + computed
                                    + " for orderId="
                                    + orderId
                                );
                            }
                        }
                    }
                }

            } catch (Exception e) {

                System.out.println(
                    "DEBUG: recompute total failed -> "
                    + e.getMessage()
                );
            }

            conn.commit();

            return orderId;

        } catch (Exception e) {

            e.printStackTrace();

            throw new RuntimeException("Error creating order", e);
        }
        
    }

    @Override
    public Order getOrderById(Long orderId) {

        String sql = """
            SELECT
                order_id,
                customer_id,
                order_date,
                total_amount,
                status,
                payment_method,
                recipient_name,
                phone_number,
                delivery_address
            FROM orders
            WHERE order_id = ?
        """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setLong(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapRowToOrder(rs);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Order> getOrdersByCustomerId(Long customerId) {

        String sql = """
            SELECT
                order_id,
                customer_id,
                order_date,
                total_amount,
                status,
                payment_method,
                recipient_name,
                phone_number,
                delivery_address
            FROM orders
            WHERE customer_id = ?
            ORDER BY order_date DESC
        """;

        List<Order> orders = new ArrayList<>();

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setLong(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    orders.add(mapRowToOrder(rs));
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<Order> getOrdersByCustomerId(Long customerId,
                                             int page,
                                             int size) {

        String sql = """
            SELECT
                order_id,
                customer_id,
                order_date,
                total_amount,
                status,
                payment_method,
                recipient_name,
                phone_number,
                delivery_address
            FROM orders
            WHERE customer_id = ?
            ORDER BY order_date DESC
            LIMIT ? OFFSET ?
        """;

        List<Order> orders = new ArrayList<>();

        int offset = (page - 1) * size;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setLong(1, customerId);
            ps.setInt(2, size);
            ps.setInt(3, offset);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    orders.add(mapRowToOrder(rs));
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public int countOrdersByCustomerId(Long customerId) {

        String sql = """
            SELECT COUNT(*)
            FROM orders
            WHERE customer_id = ?
        """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setLong(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public List<Order> getAllOrders() {

        String sql = """
            SELECT
                order_id,
                customer_id,
                order_date,
                total_amount,
                status,
                payment_method,
                recipient_name,
                phone_number,
                delivery_address
            FROM orders
            ORDER BY order_date DESC
        """;

        List<Order> orders = new ArrayList<>();

        try (
                Connection conn = DBConnection.getConnection();
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery(sql)
        ) {

            while (rs.next()) {
                orders.add(mapRowToOrder(rs));
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public void updateOrderStatus(Long orderId, String status) {

        String sql = """
            UPDATE orders
            SET status = ?
            WHERE order_id = ?
        """;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, status);
            ps.setLong(2, orderId);

            ps.executeUpdate();

        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(Long orderId) {

        String deleteOrderLineSql = """
            DELETE FROM order_line
            WHERE order_id = ?
        """;

        String deleteOrderSql = """
            DELETE FROM orders
            WHERE order_id = ?
        """;

        try (
                Connection conn = DBConnection.getConnection()
        ) {

            conn.setAutoCommit(false);

            try (
                    PreparedStatement ps =
                            conn.prepareStatement(deleteOrderLineSql)
            ) {

                ps.setLong(1, orderId);
                ps.executeUpdate();
            }

            try (
                    PreparedStatement ps =
                            conn.prepareStatement(deleteOrderSql)
            ) {

                ps.setLong(1, orderId);
                ps.executeUpdate();
            }

            conn.commit();

        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    private Order mapRowToOrder(ResultSet rs) throws SQLException {

        Timestamp ts = rs.getTimestamp("order_date");

        LocalDateTime orderDate =
                ts != null ? ts.toLocalDateTime() : null;

        Order order = new Order(
                rs.getLong("order_id"),
                rs.getLong("customer_id"),
                orderDate,
                rs.getDouble("total_amount"),
                rs.getString("status"),
                rs.getString("payment_method"),
                rs.getString("recipient_name"),
                rs.getString("phone_number"),
                rs.getString("delivery_address")
        );

        order.setRecipientName(
                rs.getString("recipient_name")
        );

        order.setPhoneNumber(
                rs.getString("phone_number")
        );

        order.setDeliveryAddress(
                rs.getString("delivery_address")
        );

        return order;
    }
}