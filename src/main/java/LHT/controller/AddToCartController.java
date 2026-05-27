package LHT.controller;

import java.io.IOException;

import LHT.dao.impl.CartDAO;
import LHT.dao.impl.CustomerDAO;
import LHT.model.Customer;
import LHT.model.User;
import LHT.service.impl.AddToCartService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-to-cart")
public class AddToCartController extends HttpServlet {

    private AddToCartService service = new AddToCartService();
    private CustomerDAO customerDAO = new CustomerDAO();
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        try {
            HttpSession session = request.getSession();

            // 1. check login
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            // 2. get productId
            String productIdParam = request.getParameter("productId");

            if (productIdParam == null || productIdParam.isEmpty()) {
                response.sendRedirect("products");
                return;
            }

            Long productId = Long.parseLong(productIdParam);

            // 3. get customer
            Customer customer = customerDAO.findByUserId(user.getUserId());

            if (customer == null) {
                throw new RuntimeException("Customer not found");
            }

            Long customerId = customer.getCustomerId();

            // 4. add to cart
            service.addToCart(user.getUserId(), productId);

            // 5. update cart count
            int cartCount = cartDAO.getCartCount(customerId);
            session.setAttribute("cartCount", cartCount);

            // 6. back to products
            response.sendRedirect("products");

        } catch (NumberFormatException e) {
            System.out.println("Product ID invalid");
            response.sendRedirect("products");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("System error");
        }
    }
}