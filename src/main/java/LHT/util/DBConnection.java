package LHT.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {


	    private static final String URL =
	            "jdbc:postgresql://ep-jolly-cell-aqw90hbv-pooler.c-8.us-east-1.aws.neon.tech/neondb?sslmode=require";
	    private static final String USER = "neondb_owner";
	    private static final String PASSWORD = "npg_jUL41SeBCHdR";

	    public static Connection getConnection() {
	        try {
	            Class.forName("org.postgresql.Driver"); // quan trọng

	            return DriverManager.getConnection(URL, USER, PASSWORD);

	        } catch (Exception e) {
	            throw new RuntimeException("DB connection failed", e);
	        }
	    }
	

    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}