package LHT.model;

public class CartItem {

    private long cartItemId;
    private Customer customer;
    private Product product;
    private int quantity;

    public CartItem() {
    }

    public CartItem(long cartItemId, Customer customer,
                    Product product, int quantity) {
        this.cartItemId = cartItemId;
        this.customer = customer;
        this.product = product;
        this.quantity = quantity;
    }

    public long getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(long cartItemId) {
        this.cartItemId = cartItemId;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
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
    
}