package LHT.service.impl;

import java.util.List;

import LHT.dao.impl.CartDAO;
import LHT.model.CartItem;
import LHT.service.ICartService;

public class CartService implements ICartService {

    CartDAO cartDAO =
            new CartDAO();

    @Override
    public void addToCart(Long customerId, Long productId) {

        cartDAO.addToCart(
                customerId,
                productId
        );
    }

    @Override
    public void updateQuantity(Long cartItemId, int quantity) {
        cartDAO.updateQuantity(cartItemId, quantity);
    }

    @Override
    public void removeFromCart(Long cartItemId) {
        cartDAO.removeItem(cartItemId);
    }

    @Override
    public void clearCart(Long customerId) {
        Long cartId = cartDAO.getCartId(customerId);
        if (cartId != null) {
            String sql = "DELETE FROM cart_item WHERE shopping_cart_id = ?"; // handled by DAO if needed
            // reuse existing DAO methods: delete each item by querying items
            List<CartItem> items = cartDAO.getCartItems(customerId);
            for (CartItem it : items) {
                cartDAO.removeItem(it.getCartItemId());
            }
        }
    }

    @Override
    public int getCartCount(Long customerId) {
        return cartDAO.getCartCount(customerId);
    }

    @Override
    public List<CartItem> getCartItems(Long customerId) {
        return cartDAO.getCartItems(customerId);
    }

    @Override
    public double getTotalPrice(Long customerId) {
        return cartDAO.getTotalPrice(customerId);
    }
}