package LHT.controller;

import LHT.model.User;
import LHT.service.impl.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginController
        extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String email =
                request.getParameter(
                        "email"
                );

        String password =
                request.getParameter(
                        "password"
                );

        UserService service =
                new UserService();

        User user =
                service.login(
                        email,
                        password
                );

        if(user != null){

            HttpSession session =
                    request.getSession();

            session.setAttribute(
                    "user",
                    user
            );

            // Redirect based on role: admin -> /admin/products, others -> /products
            String ctx = request.getContextPath();
            Long roleId = user.getRoleId();
            System.out.println(roleId);
            if (roleId != null && roleId.longValue() == 2L) {
                response.sendRedirect(ctx + "/admin/products");
            } else {
                response.sendRedirect(ctx + "/products");
            }

        } else {

            request.setAttribute(
                    "error",
                    "Invalid email or password"
            );

            request.getRequestDispatcher(
                    "login.jsp"
            ).forward(request,response);
        }
    }
}