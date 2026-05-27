package LHT.service.impl;

import LHT.dao.impl.CustomerDAO;
import LHT.model.Customer;
import LHT.model.User;
import LHT.service.ICustomerService;

public class CustomerService implements ICustomerService {
    CustomerDAO customerDAO = new CustomerDAO();
    @Override
    public Customer findCustomerByUserId(Long userId) {
        Customer customer = customerDAO.findByUserId(userId);

        if (customer == null) {
            // Attempt to create customer if it doesn't exist
            System.out.println("DEBUG: Customer not found for userId=" + userId + ", attempting to create...");
            Long customerId = customerDAO.insert(userId);

            if (customerId == null) {
                throw new RuntimeException("Customer not found for userId=" + userId);
            }
    }
        return customer;
    }
}
