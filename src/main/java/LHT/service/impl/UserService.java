package LHT.service.impl;

import java.util.Objects;

import LHT.dao.impl.CartDAO;
import LHT.dao.impl.CustomerDAO;
import LHT.dao.impl.UserDAO;
import LHT.model.User;
import LHT.service.IUserService;

public class UserService implements IUserService{

    UserDAO userDAO = new UserDAO();
    CustomerDAO customerDAO = new CustomerDAO();
    CartDAO cartDAO = new CartDAO();

    public User login(String email, String password) {
        User user = userDAO.login(email, password);
        
        if (user != null) {
            // Ensure customer record exists
            if (customerDAO.findByUserId(user.getUserId()) == null) {
                Long customerId = customerDAO.insert(user.getUserId());
                if (customerId != null) {
                    try {
                        cartDAO.createCart(customerId);
                    } catch (Exception e) {
                        throw new RuntimeException("Failed to create cart", e);
                    }
                }
            }
        }
        
        return user;
    }

    public boolean register(User user) {

        user.setRoleId(1L); // customer mặc định

        Long userId = userDAO.insert(user);
        if (userId == null) return false;

        Long customerId = customerDAO.insert(userId);
        if (customerId == null) return false;

        try {
            cartDAO.createCart(customerId);
        } catch (Exception e) {
            throw new RuntimeException("Failed to create cart", e);
        }

        return true;
    }

}