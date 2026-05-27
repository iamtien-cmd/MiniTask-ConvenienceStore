package LHT.controller;

import LHT.dao.impl.CartDAO;
import LHT.dao.impl.CustomerDAO;
import LHT.model.CartItem;
import LHT.model.User;
import LHT.service.IOrderService;
import LHT.service.impl.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private IOrderService orderService = new OrderService();
    private CustomerDAO customerDAO = new CustomerDAO();
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Long customerId = null;

        try {

            customerId =
                    customerDAO.findByUserId(user.getUserId())
                            .getCustomerId();

            // ===== get form data =====

            String recipientName =
                    request.getParameter("recipientName");

            String phoneNumber =
                    request.getParameter("phoneNumber");

            String deliveryAddress =
                    request.getParameter("deliveryAddress");

            String paymentMethod =
                    request.getParameter("paymentMethod");

            String confirmPayment =
                    request.getParameter("confirmPayment");

            boolean paymentConfirmed =
                    "yes".equals(confirmPayment);

            // ===== create order =====

         // lấy selected cart item ids từ form
            String[] selectedItems = request.getParameterValues("selectedItem");

            List<Long> selectedCartItemIds = new ArrayList<>();

            if (selectedItems != null) {

                for (String itemId : selectedItems) {

                    try {

                        selectedCartItemIds.add(
                                Long.parseLong(itemId)
                        );

                    } catch (Exception ignore) {
                    }
                }
            }

            Long orderId = orderService.createOrderFromCart(
                    customerId,
                    paymentMethod,
                    paymentConfirmed,
                    recipientName,
                    phoneNumber,
                    deliveryAddress,
                    selectedCartItemIds
            );

            if (orderId != null) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/order-details?orderId="
                                + orderId
                );

            } else {

                loadCheckoutData(request, customerId);

                request.setAttribute(
                        "error",
                        "Cannot create order"
                );

                request.getRequestDispatcher("checkout.jsp")
                        .forward(request, response);
            }

        } catch (Exception e) {

            e.printStackTrace();

            try {
                if (customerId != null) {
                    loadCheckoutData(request, customerId);
                }
            } catch (Exception ignore) {
            }

            request.setAttribute(
                    "error",
                    e.getMessage()
            );

            request.getRequestDispatcher("checkout.jsp")
                    .forward(request, response);
        }
    }

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

        try {

            Long customerId =
                    customerDAO.findByUserId(user.getUserId())
                            .getCustomerId();

            // If user came from cart with selected items, read selectedItem params
            String[] selected = request.getParameterValues("selectedItem");
            String fromCart = request.getParameter("fromCart");
            if (fromCart != null && (selected == null || selected.length == 0)) {
                // user came from cart but selected nothing -> treat as empty selection
                request.setAttribute("cartItems", new ArrayList<>());
                request.setAttribute("cartTotal", 0.0);
                request.setAttribute("totalPrice", 0.0);
                request.setAttribute("cartCount", 0);

            } else if (selected != null && selected.length > 0) {
                // filter cart items to include only selected ones
                List<CartItem> all = cartDAO.getCartItems(customerId);
                List<CartItem> filtered = new ArrayList<>();
                java.util.Set<Long> selIds = new java.util.HashSet<>();
                for (String s : selected) {
                    try { selIds.add(Long.parseLong(s)); } catch (Exception ignore) {}
                }
                for (CartItem ci : all) {
                    if (selIds.contains(ci.getCartItemId())) filtered.add(ci);
                }

                // compute totals for filtered list
                double subtotal = 0.0;
                for (CartItem ci : filtered) subtotal += ci.getProduct().getPrice() * ci.getQuantity();

                request.setAttribute("cartItems", filtered);
                request.setAttribute("cartTotal", subtotal);
                request.setAttribute("totalPrice", subtotal);
                request.setAttribute("cartCount", filtered.size());

            } else {
                loadCheckoutData(request, customerId);
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "cartItems",
                    new ArrayList<>()
            );

            request.setAttribute(
                    "totalPrice",
                    0.0
            );
        }

        request.getRequestDispatcher("/checkout.jsp")
                .forward(request, response);
    }

    private void loadCheckoutData(HttpServletRequest request,
                                  Long customerId) {

        List<CartItem> cartItems =
                cartDAO.getCartItems(customerId);

        double totalPrice =
                cartDAO.getTotalPrice(customerId);

        int cartCount =
                cartDAO.getCartCount(customerId);

        request.setAttribute(
                "cartItems",
                cartItems
        );

        request.setAttribute(
                "cartTotal",
                totalPrice
        );

        request.setAttribute(
                "totalPrice",
                totalPrice
        );

        request.setAttribute(
                "cartCount",
                cartCount
        );
    }
}