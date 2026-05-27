package LHT.service;

import java.util.List;

import LHT.model.CartItem;

public interface ICartService {
    void addToCart(Long customerId, Long productId);
    void updateQuantity(Long cartItemId, int quantity);
    void removeFromCart(Long cartItemId);
    void clearCart(Long customerId);
    int getCartCount(Long customerId);
    List<CartItem> getCartItems(Long customerId);
    double getTotalPrice(Long customerId);
}
