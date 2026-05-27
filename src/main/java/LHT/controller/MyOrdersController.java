package LHT.controller;

import java.io.IOException;
import java.util.List;

import LHT.dao.impl.CustomerDAO;
import LHT.model.Customer;
import LHT.model.Order;
import LHT.model.User;
import LHT.service.IOrderService;
import LHT.service.impl.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/my-orders")
public class MyOrdersController extends HttpServlet {

    private IOrderService orderService = new OrderService();
    private CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        Customer customer = customerDAO.findByUserId(user.getUserId());
        Long customerId;
        if (customer == null) {
            // create customer record for this user
            Long newCustomerId = customerDAO.insert(user.getUserId());
            if (newCustomerId == null) {
                // fallback to using userId as customerId if insertion failed
                customerId = user.getUserId();
            } else {
                customerId = newCustomerId;
            }
        } else {
            customerId = customer.getCustomerId();
        }

        int page = 1;
        int pageSize = 10; // 10 items per page
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Math.max(1, Integer.parseInt(pageParam));
            } catch (NumberFormatException ignored) {
            }
        }

        List<Order> orders = orderService.getCustomerOrders(customerId, page, pageSize);
        System.out.println("DEBUG: MyOrdersController userId=" + user.getUserId() + ", customerId=" + customerId + ", page=" + page + ", pageSize=" + pageSize + ", returnedOrders=" + (orders==null?0:orders.size()));
        if (orders == null || orders.isEmpty()) {
            // fallback: try non-paginated retrieval to diagnose
            List<Order> fallback = orderService.getCustomerOrders(customerId);
            System.out.println("DEBUG: MyOrdersController fallback non-paged returned=" + (fallback==null?0:fallback.size()));
            if (fallback != null && !fallback.isEmpty()) orders = fallback;
        }

        int totalOrders = orderService.countCustomerOrders(customerId);
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/my-orders.jsp").forward(request, response);
    }
}
