package LHT.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import LHT.model.Customer;
import LHT.model.User;
import LHT.util.DBConnection;

public class CustomerDAO {

    public Long insert(Long userId) {

        String sql = """
            INSERT INTO customers(user_id)
            VALUES (?)
            RETURNING customer_id
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getLong(1);
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return null;
    }

    public Customer findByUserId(Long userId) {

        String sql = """
            SELECT customer_id, user_id
            FROM customers
            WHERE user_id = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Customer customer = new Customer();
                customer.setCustomerId(rs.getLong("customer_id"));

                User user = new User();
                user.setUserId(rs.getLong("user_id"));

                customer.setUser(user);

                return customer;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
