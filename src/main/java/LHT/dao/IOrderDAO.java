package LHT.dao;

import java.util.List;

import LHT.model.Order;

public interface IOrderDAO {
    /**
     * Create a new order from cart items
     */
	 public Long createOrder(Long customerId,
             String status,
             String paymentMethod,
             String recipientName,
             String phoneNumber,
             String deliveryAddress);
    
    /**
     * Get order by ID
     */
    Order getOrderById(Long orderId);
    
    /**
     * Get all orders for a customer
     */
    List<Order> getOrdersByCustomerId(Long customerId);
    
    /**
     * Get all orders for a customer with pagination
     */
    List<Order> getOrdersByCustomerId(Long customerId, int page, int size);

    /**
     * Count orders for a customer
     */
    int countOrdersByCustomerId(Long customerId);
    
    /**
     * Get all orders (admin view)
     */
    List<Order> getAllOrders();
    
    /**
     * Update order status
     */
    void updateOrderStatus(Long orderId, String status);
    
    /**
     * Delete order
     */
    void deleteOrder(Long orderId);
}
