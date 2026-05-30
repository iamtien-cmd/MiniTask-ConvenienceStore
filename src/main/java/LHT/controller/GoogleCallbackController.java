package LHT.controller;

import java.io.IOException;

import LHT.model.GoogleTokenResponse;
import LHT.model.User;
import LHT.service.impl.GoogleAuthService;
import LHT.service.impl.UserService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/auth/google/callback")
public class GoogleCallbackController extends HttpServlet {

    private GoogleAuthService authService = new GoogleAuthService();
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String code = req.getParameter("code");

        // 1. Exchange code → token
        GoogleTokenResponse token = authService.getToken(code);

        // 2. Get user info
        User googleUser = authService.getUserInfo(token.getAccessToken());

        // 3. Check or create user in DB
        User user = userService.loginOrRegisterGoogleUser(googleUser);

        // 4. Create session
        HttpSession session = req.getSession();
        session.setAttribute("user", user);

        resp.sendRedirect(req.getContextPath() + "/home.jsp");
    }
}
