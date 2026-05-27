package LHT.dto;

import java.time.LocalDateTime;

public class OrderDetailDTO {

    // Product info
    private long productId;
    private String productName;
    private double unitPrice;
    private int quantity;
    private double totalPrice;

    // Order info
    private long orderId;
    private long customerId;
    private LocalDateTime orderDate;
    private double totalAmount;
    private String status;
    private String paymentMethod;

    // delivery/recipient
    private String recipientName;
    private String phoneNumber;
    private String address;

    public OrderDetailDTO() {
    }

    public OrderDetailDTO(long productId,
                          String productName,
                          double unitPrice,
                          int quantity,
                          double totalPrice) {

        this.productId = productId;
        this.productName = productName;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public long getOrderId() {
        return orderId;
    }

    public void setOrderId(long orderId) {
        this.orderId = orderId;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

   

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public static OrderDetailDTO fromResultSet(java.sql.ResultSet rs) {
        try {
            OrderDetailDTO dto = new OrderDetailDTO();

            // product / line
            try { dto.setProductId(rs.getLong("product_id")); } catch (Exception ignore) {}
            try { dto.setProductName(rs.getString("product_name")); } catch (Exception ignore) {}
            try { dto.setQuantity(rs.getInt("quantity")); } catch (Exception ignore) {}
            try { dto.setUnitPrice(rs.getDouble("unit_price")); } catch (Exception ignore) {}
            try { dto.setTotalPrice(rs.getDouble("total_price")); } catch (Exception ignore) {}

            // order-level (if selected)
            try { dto.setOrderId(rs.getLong("order_id")); } catch (Exception ignore) {}
            try { dto.setCustomerId(rs.getLong("customer_id")); } catch (Exception ignore) {}
            try {
                java.sql.Timestamp ts = rs.getTimestamp("order_date");
                if (ts != null) dto.setOrderDate(ts.toLocalDateTime());
            } catch (Exception ignore) {}
            try { dto.setTotalAmount(rs.getDouble("total_amount")); } catch (Exception ignore) {}
            try { dto.setStatus(rs.getString("status")); } catch (Exception ignore) {}
            try { dto.setPaymentMethod(rs.getString("payment_method")); } catch (Exception ignore) {}

            // delivery / customer info
            try { dto.setRecipientName(rs.getString("recipient_name")); } catch (Exception ignore) {}
            try { dto.setPhoneNumber(rs.getString("phone_number")); } catch (Exception ignore) {}
            try { dto.setAddress(rs.getString("delivery_address")); } catch (Exception ignore) {}

            return dto;
        } catch (Exception e) {
            return null;
        }
    }

}