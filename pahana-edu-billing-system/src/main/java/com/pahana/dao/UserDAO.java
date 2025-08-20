package com.pahana.dao;

import com.pahana.model.User;
import com.pahana.util.DBConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    
	public User getUserByUsername(String username) {
	    String query = "SELECT * FROM user WHERE username = ?";
	    User user = null;

	    try (Connection conn = DBConnectionFactory.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query)) {

	        stmt.setString(1, username);
	        ResultSet rs = stmt.executeQuery();

	        if (rs.next()) {
	            user = new User();
	            user.setUserId(rs.getInt("userId"));
	            user.setUsername(rs.getString("username"));
	            user.setPassword(rs.getString("password"));
	            user.setRole(rs.getString("role"));
	        }

	    } catch (SQLException e) {
	        System.err.println("Error getting user by username: " + e.getMessage());
	        e.printStackTrace();
	    }

	    return user;
	}


	public List<User> getAllUsers() {
	    List<User> users = new ArrayList<>();
	    String query = "SELECT * FROM user ORDER BY userId";

	    try (Connection conn = DBConnectionFactory.getConnection();
	         Statement stmt = conn.createStatement();
	         ResultSet rs = stmt.executeQuery(query)) {

	        while (rs.next()) {
	            User user = new User();
	            user.setUserId(rs.getInt("userId"));
	            user.setUsername(rs.getString("username"));
	            user.setPassword(rs.getString("password"));
	            user.setRole(rs.getString("role"));

	            users.add(user);
	        }

	    } catch (SQLException e) {
	        System.err.println("Error getting all users: " + e.getMessage());
	        e.printStackTrace();
	    }

	    return users;
	}



 
    public boolean validateUser(String username, String password) {
        String query = "SELECT * FROM user WHERE username = ? AND password = ?";
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
    

    public boolean addUser(User user) {
        String query = "INSERT INTO user (username, password, role) VALUES (?, ?, ?)";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getRole());

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteUser(int userId) {
        String query = "DELETE FROM user WHERE userId = ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userId);
            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

}
