package LHT.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import LHT.model.User;
import LHT.service.IProductService;
import LHT.service.impl.ProductService;

import java.io.IOException;

@WebServlet("/admin/products")
public class AdminProductController extends HttpServlet {

    private IProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            // show add form
            request.setAttribute("product", null);
            request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
            return;
        } else if ("edit".equals(action)) {
            String id = request.getParameter("productId");
            try {
                Long pid = Long.parseLong(id);
                var prod = productService.getProductById(pid);
                request.setAttribute("product", prod);
                request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
                return;
            } catch (Exception ignore) {
                // fallback to list
            }
        }

        var products = productService.getAllProducts();
        request.setAttribute("products", products);

        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        System.out.println("DEBUG AdminProductController POST action=" + action);

        try {
            // Server-side validation for add/update
            if ("add".equals(action) || "update".equals(action) || "edit".equals(action)) {
                String name = request.getParameter("productName");
                String priceS = request.getParameter("price");
                String stockS = request.getParameter("stockQuantity");

                StringBuilder err = new StringBuilder();
                double price = 0.0;
                int stock = 0;

                if (name == null || name.trim().isEmpty()) {
                    err.append("Product name is required. ");
                }

                try {
                    price = Double.parseDouble(priceS);
                    if (price < 0) err.append("Price cannot be negative. ");
                } catch (Exception ex) {
                    err.append("Invalid price. ");
                }

                try {
                    stock = Integer.parseInt(stockS);
                    if (stock < 0) err.append("Stock cannot be negative. ");
                } catch (Exception ex) {
                    err.append("Invalid stock quantity. ");
                }

                if (err.length() > 0) {
                    // forward back to form with entered values
                    request.setAttribute("error", err.toString());
                    LHT.model.Product p = new LHT.model.Product();
                    String idS = request.getParameter("productId");
                    try { if (idS != null) p.setProductId(Long.parseLong(idS)); } catch (Exception ignore) {}
                    p.setProductName(name);
                    p.setPrice(price);
                    p.setStockQuantity(stock);
                    p.setImageUrl(request.getParameter("imageUrl"));
                    p.setDescription(request.getParameter("description"));
                    request.setAttribute("product", p);
                    request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
                    return;
                }
            }

            if ("add".equals(action)) {
                handleAddProduct(request, response);
            } else if ("update".equals(action) || "edit".equals(action)) {
                handleUpdateProduct(request, response);
            } else if ("delete".equals(action)) {
                String pidS = request.getParameter("productId");
                System.out.println("DEBUG AdminProductController delete productId param='" + pidS + "'");
                try {
                    Long productId = Long.parseLong(pidS);
                    handleDeleteProduct(request, response);
                } catch (NumberFormatException nfe) {
                    System.out.println("DEBUG AdminProductController invalid productId: " + pidS);
                    throw new RuntimeException("Invalid productId: " + pidS);
                }
            }

            // Redirect back to products list
            response.sendRedirect(request.getContextPath() + "/admin/products");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }

    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("productName");
        String priceS = request.getParameter("price");
        String stockS = request.getParameter("stockQuantity");
        String imageUrl = request.getParameter("imageUrl");
        String description = request.getParameter("description");

        double price = 0.0;
        int stock = 0;
        try { price = Double.parseDouble(priceS); } catch (Exception ignore) {}
        try { stock = Integer.parseInt(stockS); } catch (Exception ignore) {}

        LHT.model.Product p = new LHT.model.Product();
        p.setProductName(name);
        p.setPrice(price);
        p.setStockQuantity(stock);
        p.setImageUrl(imageUrl);
        p.setDescription(description);

        productService.addProduct(p);
    }

    private void handleUpdateProduct(HttpServletRequest request, HttpServletResponse response) {
        String idS = request.getParameter("productId");
        String name = request.getParameter("productName");
        String priceS = request.getParameter("price");
        String stockS = request.getParameter("stockQuantity");
        String imageUrl = request.getParameter("imageUrl");
        String description = request.getParameter("description");

        try {
            Long id = Long.parseLong(idS);
            double price = 0.0;
            int stock = 0;
            try { price = Double.parseDouble(priceS); } catch (Exception ignore) {}
            try { stock = Integer.parseInt(stockS); } catch (Exception ignore) {}

            LHT.model.Product p = new LHT.model.Product();
            p.setProductId(id);
            p.setProductName(name);
            p.setPrice(price);
            p.setStockQuantity(stock);
            p.setImageUrl(imageUrl);
            p.setDescription(description);

            productService.updateProduct(p);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void handleDeleteProduct(HttpServletRequest request, HttpServletResponse response) {
        Long productId = Long.parseLong(request.getParameter("productId"));
        productService.deleteProduct(productId);
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Long roleId = user != null ? user.getRoleId() : null;
        return user != null && roleId != null && roleId.longValue() == 2L; // Admin role
    }
}
