package LHT.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import LHT.dao.impl.OrderDetailDAO;
import LHT.dto.OrderDetailDTO;
import LHT.model.Order;
import LHT.model.User;
import LHT.service.ICustomerService;
import LHT.service.IOrderService;
import LHT.service.impl.CustomerService;
import LHT.service.impl.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/order-details")
public class OrderDetailsController extends HttpServlet {

    private IOrderService orderService = new OrderService();
    private ICustomerService customerService = new CustomerService();
    private OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String orderIdParam = request.getParameter("orderId");

        if (orderIdParam == null) {
            response.sendRedirect("my-orders");
            return;
        }

        Long orderId;

        try {
            orderId = Long.parseLong(orderIdParam);
        } catch (Exception e) {
            response.sendRedirect("my-orders");
            return;
        }

        Long customerId =
                customerService
                        .findCustomerByUserId(user.getUserId())
                        .getCustomerId();

        Order order = orderService.getOrderDetails(orderId);

        if (order == null ||
                !Long.valueOf(order.getCustomerId())
                        .equals(customerId)) {

            response.sendRedirect("my-orders");
            return;
        }

        List<OrderDetailDTO> items = new ArrayList<>();

        try {

            items =
                    orderDetailDAO.getOrderDetailByOrderId(orderId);

        } catch (Exception e) {

            e.printStackTrace();
        }

        request.setAttribute("order", order);
        request.setAttribute("items", items);

        request.getRequestDispatcher("/order-details.jsp")
                .forward(request, response);
    }
}