package LHT.controller;

import java.io.IOException;

import LHT.model.User;
import LHT.service.IOrderService;
import LHT.service.impl.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/orders")
public class AdminOrderController extends HttpServlet {

    private IOrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        var orders = orderService.getAllOrders();
        request.setAttribute("orders", orders);

        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String orderIdParam = request.getParameter("orderId");
        Long orderId = null;
        try {
            orderId = Long.parseLong(orderIdParam);
        } catch (Exception e) {
            throw new RuntimeException("Invalid orderId: " + orderIdParam);
        }

        try {
            if ("update-status".equals(action)) {
                String status = request.getParameter("status");
                orderService.updateOrderStatus(orderId, status);
            } else if ("cancel".equals(action)) {
                orderService.cancelOrder(orderId);
            }

            response.sendRedirect(request.getContextPath() + "/admin/orders");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Long roleId = user != null ? user.getRoleId() : null;
        return user != null && roleId != null && roleId.longValue() == 2L; // Admin role
    }
}
