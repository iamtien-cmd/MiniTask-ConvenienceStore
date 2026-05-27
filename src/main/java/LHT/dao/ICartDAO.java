package LHT.dao;

import java.util.List;

import LHT.model.CartItem;

public interface ICartDAO {
	public void createCart(Long customerId);
	public void addToCart(Long customerId, Long productId);
	public Long getCartId(Long customerId);
	public int getCartCount(Long customerId);
	public List<CartItem> getCartItems(Long customerId);
	public double getTotalPrice(Long customerId);
	public void updateQuantity(Long cartItemId, int quantity);
	public void removeItem(Long cartItemId);
	public void clearCart(Long customerId);
}
