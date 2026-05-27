package LHT.controller;

import java.io.IOException;
import java.util.List;

import LHT.dao.impl.CartDAO;
import LHT.dao.impl.CustomerDAO;
import LHT.model.CartItem;
import LHT.model.Customer;
import LHT.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();
    private CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Customer customer = customerDAO.findByUserId(user.getUserId());

        if (customer == null) {
            response.sendRedirect("products");
            return;
        }

        Long customerId = customer.getCustomerId();

        List<CartItem> items = cartDAO.getCartItems(customerId);
        double total = cartDAO.getTotalPrice(customerId);

        request.setAttribute("cartItems", items);
        request.setAttribute("totalPrice", total);

        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String action = request.getParameter("action");
        System.out.println("ACTION = " + action);

        if ("update".equals(action)) {
            Long cartItemId = Long.parseLong(request.getParameter("cartItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            cartDAO.updateQuantity(cartItemId, quantity);
        }

        if ("remove".equals(action)) {
            Long cartItemId = Long.parseLong(request.getParameter("cartItemId"));

            cartDAO.removeItem(cartItemId);
        }

        response.setContentType("application/json");
        response.getWriter().write("{\"success\":true}");
    }
}