package LHT.service;

import LHT.model.Order;

import java.util.List;

public interface IOrderService {

    Long createOrderFromCart(
            Long customerId,
            String paymentMethod,
            boolean paymentConfirmed,
            String recipientName,
            String phoneNumber,
            String deliveryAddress,
            List<Long> selectedCartItemIds
    );

    Order getOrderDetails(Long orderId);

    List<Order> getCustomerOrders(Long customerId);

    List<Order> getCustomerOrders(
            Long customerId,
            int page,
            int size
    );

    int countCustomerOrders(Long customerId);

    List<Order> getAllOrders();

    void updateOrderStatus(Long orderId, String status);

    void cancelOrder(Long orderId);
}