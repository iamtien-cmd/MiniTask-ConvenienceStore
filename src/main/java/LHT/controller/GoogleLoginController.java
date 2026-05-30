package LHT.controller;

import java.io.IOException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/auth/google/login")
public class GoogleLoginController extends HttpServlet {

    private static final String CLIENT_ID =System.getenv("GOOGLE_CLIENT_ID");
    private static final String REDIRECT_URI = "http://localhost:8080/Task_7-Eleven/auth/google/callback";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String url = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + CLIENT_ID
                + "&redirect_uri=" + REDIRECT_URI
                + "&response_type=code"
                + "&scope=openid%20email%20profile"
                + "&access_type=offline"
                + "&prompt=consent";

        resp.sendRedirect(url);
    }
}