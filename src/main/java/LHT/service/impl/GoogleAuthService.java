package LHT.service.impl;

import java.io.IOException;

import LHT.model.GoogleTokenResponse;
import LHT.model.User;
import LHT.util.HttpUtil;
import LHT.util.JsonUtil;

public class GoogleAuthService {

    private static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");
    private static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET ");
    private static final String REDIRECT_URI = "http://localhost:8080/Task_7-Eleven/auth/google/callback";
   
    public GoogleTokenResponse getToken(String code) throws IOException {

        String url = "https://oauth2.googleapis.com/token";

        String params =
                "code=" + code +
                "&client_id=" + CLIENT_ID +
                "&client_secret=" + CLIENT_SECRET +
                "&redirect_uri=" + REDIRECT_URI +
                "&grant_type=authorization_code";

        String response = HttpUtil.postForm(url, params);

        return JsonUtil.fromJson(response, GoogleTokenResponse.class);
    }

    public User getUserInfo(String accessToken) throws IOException {

        String url = "https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken;

        String response = HttpUtil.get(url);

        return JsonUtil.fromJson(response,User.class);
    }
}
