package LHT.model;

import java.time.LocalDateTime;

public class ShoppingCart {

    private long shoppingCartId;
    private Customer customer;
    private LocalDateTime createAt;

    public ShoppingCart() {
    }

    public ShoppingCart(long shoppingCartId, Customer customer, LocalDateTime createAt) {
        this.shoppingCartId = shoppingCartId;
        this.customer = customer;
        this.createAt = createAt;
    }

    public long getShoppingCartId() {
        return shoppingCartId;
    }

    public void setShoppingCartId(long shoppingCartId) {
        this.shoppingCartId = shoppingCartId;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

	public LocalDateTime getCreateAt() {
		return createAt;
	}

	public void setCreateAt(LocalDateTime createAt) {
		this.createAt = createAt;
	}
    
}
