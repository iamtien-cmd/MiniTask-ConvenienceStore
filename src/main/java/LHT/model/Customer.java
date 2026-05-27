package LHT.model;

public class Customer {

    private long customerId;
    private User user;

    public Customer() {
    }

    public Customer(long customerId, User user) {
        this.customerId = customerId;
        this.user = user;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
