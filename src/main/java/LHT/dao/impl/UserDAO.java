package LHT.dao.impl;

import LHT.model.User;
import LHT.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	public Long insert(User user) {

	    String sql = """
	        INSERT INTO users(
	            full_name,
	            email,
	            password_hash,
	            address,
	            role_id
	        )
	        VALUES (?,?,?,?,?)
	        RETURNING user_id
	    """;

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setString(1, user.getFullName());
	        ps.setString(2, user.getEmail());
	        ps.setString(3, user.getPasswordHash());
	        ps.setString(4, user.getAddress());
	        ps.setLong(5, user.getRoleId()); // ❗ FIX HERE

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            return rs.getLong(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return null;
	}
	public boolean register(User user) {

		String sql = """
				    INSERT INTO users(
				        full_name,
				        email,
				        password_hash,
				        address,
				        role_id
				    )
				    VALUES(?,?,?,?,?)
				""";

		try (

				Connection conn = DBConnection.getConnection();

				PreparedStatement ps = conn.prepareStatement(sql);

		) {

			ps.setString(1, user.getFullName());

			ps.setString(2, user.getEmail());

			ps.setString(3, user.getPasswordHash());

			ps.setString(4, user.getAddress());

			ps.setLong(5, 1);

			int rows = ps.executeUpdate();

			return rows > 0;

		} catch (Exception e) {

			e.printStackTrace();
		}

		return false;
	}

	public User login(String email, String password) {
		{

			String sql = """
					  SELECT *
					  FROM users
					  WHERE email = ?
					  AND password_hash = ?
					""";

			try {

				Connection conn = DBConnection.getConnection();

				PreparedStatement ps = conn.prepareStatement(sql);

				ps.setString(1, email);

				ps.setString(2, password);

				ResultSet rs = ps.executeQuery();

				if (rs.next()) {

					User user = new User();

					user.setUserId(rs.getLong("user_id"));

					user.setFullName(rs.getString("full_name"));

					user.setEmail(rs.getString("email"));
					user.setRoleId(rs.getLong("role_id"));
					return user;
				}

			} catch (Exception e) {

				e.printStackTrace();
			}

			return null;
		}
	}
}