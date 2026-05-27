package LHT.service.impl;

import LHT.dao.impl.CartDAO;
import LHT.dao.impl.CustomerDAO;
import LHT.model.Customer;

public class AddToCartService {

	CartDAO cartDAO = new CartDAO();
	CustomerService customerService = new CustomerService();

	public void addToCart(Long userId, Long productId) {
		// 1. Find Customer
	    Customer customer = customerService.findCustomerByUserId(userId);
		Long customerId = customer.getCustomerId();
		// 2. Create Cart
		cartDAO.addToCart(customerId, productId);

	}
}