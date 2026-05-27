package LHT.service.impl;

import LHT.dao.ICartDAO;
import LHT.dao.IOrderDAO;
import LHT.dao.impl.OrderDAO;
import LHT.dao.impl.CartDAO;
import LHT.model.CartItem;
import LHT.model.Order;
import LHT.service.IOrderService;
import LHT.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

public class OrderService implements IOrderService {

    private IOrderDAO orderDAO = new OrderDAO();
    private ICartDAO cartDAO = new CartDAO();

    @Override
    public Long createOrderFromCart(
            Long customerId,
            String paymentMethod,
            boolean paymentConfirmed,
            String recipientName,
            String phoneNumber,
            String deliveryAddress,
            List<Long> selectedCartItemIds
    ) {
        if (!paymentConfirmed) {
            throw new RuntimeException("Payment not confirmed");
        }

        // Compute totalAmount BEFORE creating the order so DAO clearing the cart won't make it 0
        double subtotal;
        if (selectedCartItemIds != null && !selectedCartItemIds.isEmpty()) {
            subtotal = 0.0;
            List<CartItem> items = cartDAO.getCartItems(customerId);
            for (CartItem ci : items) {
                if (selectedCartItemIds.contains(ci.getCartItemId())) {
                    subtotal += ci.getProduct().getPrice() * ci.getQuantity();
                }
            }
        } else {
            subtotal = cartDAO.getTotalPrice(customerId);
        }

        // Shipping policy: flat shipping per order; tax disabled per request
        double shippingFee = 5.00; // flat per order
        double taxAmount = 0.00; // tax disabled

        double totalAmount = Math.round((subtotal + shippingFee) * 100.0) / 100.0;

        System.out.println("DEBUG: computed cart subtotal (pre-create) = " + subtotal + " shipping=" + shippingFee + " tax=" + taxAmount + " total=" + totalAmount + " for customer " + customerId);

        // Create order
        Long orderId = orderDAO.createOrder(
                customerId,
                "PENDING",
                paymentMethod,
                recipientName,
                phoneNumber,
                deliveryAddress
        );

        if (orderId != null) {
            System.out.println("DEBUG: created orderId=" + orderId);

            // Attempt to update order with payment info and total using detected column names
            try (Connection conn = DBConnection.getConnection()) {

                // Ensure required orders columns exist (create if missing)
                try {
                    ensureOrderColumns(conn);
                } catch (Exception e) {
                    System.out.println("DEBUG: ensureOrderColumns failed: " + e.getMessage());
                }

                // helper to find existing column
                String findSql = "SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = ? LIMIT 1";
                String totalCol = null;
                String paymentCol = null;
                String statusCol = null;

                try (PreparedStatement ps = conn.prepareStatement(findSql)) {
                    String[] totals = {"total_amount", "total", "amount"};
                    for (String c : totals) {
                        ps.setString(1, c);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) { totalCol = c; break; }
                        }
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(findSql)) {
                    String[] pays = {"payment_method", "payment", "paymenttype"};
                    for (String c : pays) {
                        ps.setString(1, c);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) { paymentCol = c; break; }
                        }
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(findSql)) {
                    String[] stats = {"status", "order_status", "state", "orderstate"};
                    for (String c : stats) {
                        ps.setString(1, c);
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) { statusCol = c; break; }
                        }
                    }
                }

                System.out.println("DEBUG: order columns detected totalCol=" + totalCol + ", paymentCol=" + paymentCol + ", statusCol=" + statusCol);

                StringBuilder update = new StringBuilder();
                java.util.List<Object> params = new java.util.ArrayList<>();

                if (totalCol != null) {
                    update.append(totalCol).append(" = ?");
                    params.add(totalAmount);
                }
                if (paymentCol != null) {
                    if (update.length() > 0) update.append(", ");
                    update.append(paymentCol).append(" = ?");
                    params.add(paymentMethod);
                }
                if (statusCol != null) {
                    if (update.length() > 0) update.append(", ");
                    update.append(statusCol).append(" = ?");
                    params.add("CONFIRMED");
                }

                if (update.length() > 0) {
                    String updSql = String.format("UPDATE orders SET %s WHERE order_id = ?", update.toString());
                    try (PreparedStatement ups = conn.prepareStatement(updSql)) {
                        for (int i = 0; i < params.size(); i++) {
                            ups.setObject(i + 1, params.get(i));
                        }
                        ups.setLong(params.size() + 1, orderId);
                        int rows = ups.executeUpdate();
                        System.out.println("DEBUG: update order rows=" + rows + ", sql=" + updSql);
                    }
                } else {
                    System.out.println("DEBUG: No matching order columns to update.");
                }

                // Ensure total_amount column receives the computed total as a fallback
                try {
                    String explicitSql = "UPDATE orders SET total_amount = ? WHERE order_id = ?";
                    try (PreparedStatement psExplicit = conn.prepareStatement(explicitSql)) {
                        psExplicit.setDouble(1, totalAmount);
                        psExplicit.setLong(2, orderId);
                        int explicitRows = psExplicit.executeUpdate();
                        System.out.println("DEBUG: explicit update total_amount rows=" + explicitRows + ", sql=" + explicitSql);
                    }
                } catch (Exception e) {
                    // ignore if column does not exist or update fails
                    System.out.println("DEBUG: explicit update for total_amount failed: " + e.getMessage());
                }

                // Ensure payment_method column is set (fallback)
                try {
                    String explicitPay = "UPDATE orders SET payment_method = ? WHERE order_id = ?";
                    try (PreparedStatement psPay = conn.prepareStatement(explicitPay)) {
                        psPay.setString(1, paymentMethod);
                        psPay.setLong(2, orderId);
                        int rowsPay = psPay.executeUpdate();
                        System.out.println("DEBUG: explicit update payment_method rows=" + rowsPay + ", sql=" + explicitPay);
                    }
                } catch (Exception e) {
                    System.out.println("DEBUG: explicit update for payment_method failed: " + e.getMessage());
                }

                // Persist shipping_amount and tax_amount (fallback)
                try {
                    String explicitShip = "UPDATE orders SET shipping_amount = ? WHERE order_id = ?";
                    try (PreparedStatement psShip = conn.prepareStatement(explicitShip)) {
                        psShip.setDouble(1, shippingFee);
                        psShip.setLong(2, orderId);
                        int rowsShip = psShip.executeUpdate();
                        System.out.println("DEBUG: explicit update shipping_amount rows=" + rowsShip + ", sql=" + explicitShip);
                    }
                } catch (Exception e) {
                    System.out.println("DEBUG: explicit update for shipping_amount failed: " + e.getMessage());
                }

                try {
                    String explicitTax = "UPDATE orders SET tax_amount = ? WHERE order_id = ?";
                    try (PreparedStatement psTax = conn.prepareStatement(explicitTax)) {
                        psTax.setDouble(1, taxAmount);
                        psTax.setLong(2, orderId);
                        int rowsTax = psTax.executeUpdate();
                        System.out.println("DEBUG: explicit update tax_amount rows=" + rowsTax + ", sql=" + explicitTax);
                    }
                } catch (Exception e) {
                    System.out.println("DEBUG: explicit update for tax_amount failed: " + e.getMessage());
                }

                // Ensure order_date is set to NOW() if missing
                try {
                    String explicitDate = "UPDATE orders SET order_date = NOW() WHERE order_id = ? AND (order_date IS NULL)";
                    try (PreparedStatement psDate = conn.prepareStatement(explicitDate)) {
                        psDate.setLong(1, orderId);
                        int rowsDate = psDate.executeUpdate();
                        System.out.println("DEBUG: explicit update order_date rows=" + rowsDate + ", sql=" + explicitDate);
                    }
                } catch (Exception e) {
                    System.out.println("DEBUG: explicit update for order_date failed: " + e.getMessage());
                }

                // Clear cart after successful order
                cartDAO.clearCart(customerId);

                System.out.println("Order " + orderId + " created successfully with total " + totalAmount);
                return orderId;

            } catch (Exception e) {
                throw new RuntimeException("Error creating order", e);
            }
        }

        return null;
    }

    @Override
    public Order getOrderDetails(Long orderId) {
        return orderDAO.getOrderById(orderId);
    }

    @Override
    public List<Order> getCustomerOrders(Long customerId) {
        return orderDAO.getOrdersByCustomerId(customerId);
    }

    @Override
    public List<Order> getCustomerOrders(Long customerId, int page, int size) {
        return orderDAO.getOrdersByCustomerId(customerId, page, size);
    }

    @Override
    public int countCustomerOrders(Long customerId) {
        return orderDAO.countOrdersByCustomerId(customerId);
    }

    @Override
    public List<Order> getAllOrders() {
        return orderDAO.getAllOrders();
    }

    @Override
    public void updateOrderStatus(Long orderId, String status) {
        orderDAO.updateOrderStatus(orderId, status);
    }

    @Override
    public void cancelOrder(Long orderId) {
        orderDAO.updateOrderStatus(orderId, "CANCELLED");
    }

    private void ensureOrderColumns(Connection conn) {
        String[] stmts = new String[] {
            "ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS payment_method TEXT",
            "ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS total_amount NUMERIC DEFAULT 0",
            "ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS order_date TIMESTAMP",
            "ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'PENDING'",
            "ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS delivery_address TEXT",
            "ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS shipping_amount NUMERIC DEFAULT 0",
            "ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS tax_amount NUMERIC DEFAULT 0"
        };

        for (String s : stmts) {
            try (PreparedStatement ps = conn.prepareStatement(s)) {
                ps.execute();
            } catch (Exception ignore) {
                System.out.println("DEBUG: ensureOrderColumns statement failed: " + s + " -> " + ignore.getMessage());
            }
        }
    }
}
