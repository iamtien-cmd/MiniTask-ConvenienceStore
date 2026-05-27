package LHT.model;

public class OrderLine {

    private long orderLineId;
    private ShoppingCart shoppingCart;
    private Product product;
    private int quantity;
    private Order order;

    public OrderLine() {
    }

    public OrderLine(long orderLineId, ShoppingCart shoppingCart,
                     Product product, int quantity,Order order) {
        this.orderLineId = orderLineId;
        this.shoppingCart = shoppingCart;
        this.product = product;
        this.quantity = quantity;
        this.order = order;
    }

    public long getOrderLineId() {
        return orderLineId;
    }

    public void setOrderLineId(long orderLineId) {
        this.orderLineId = orderLineId;
    }

    public ShoppingCart getShoppingCart() {
        return shoppingCart;
    }

    public void setShoppingCart(ShoppingCart shoppingCart) {
        this.shoppingCart = shoppingCart;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

	public Order getOrder() {
		return order;
	}

	public void setOrder(Order order) {
		this.order = order;
	}
    
}
