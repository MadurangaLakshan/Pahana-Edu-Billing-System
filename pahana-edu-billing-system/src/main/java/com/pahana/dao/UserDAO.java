package com.pahana.dao;

import com.pahana.model.User;
import com.pahana.util.DBConnectionFactory;

import java.sql.*;

public class UserDAO {

    
    public User getUserByUsername(String username) {
        String query = "SELECT * FROM User WHERE username = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new User(
                    rs.getInt("userId"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

 
    public boolean validateUser(String username, String password) {
        String query = "SELECT * FROM User WHERE username = ? AND password = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            return rs.next(); // if a row exists, credentials are valid

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
