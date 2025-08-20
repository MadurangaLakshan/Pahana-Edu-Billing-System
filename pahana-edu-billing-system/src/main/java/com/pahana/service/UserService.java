package com.pahana.service;

import java.util.List;

import com.pahana.dao.UserDAO;
import com.pahana.model.Customer;
import com.pahana.model.User;

public class UserService {

    private static UserService instance;
    private UserDAO userDAO;

    private UserService() {
        this.userDAO = new UserDAO();
    }

    public static UserService getInstance() {
        if (instance == null) {
            synchronized (UserService.class) {
                if (instance == null) {
                    instance = new UserService();
                }
            }
        }
        return instance;
    }

    public User login(String username, String password) {
        boolean valid = userDAO.validateUser(username, password);
        if (valid) {
            return userDAO.getUserByUsername(username);
        }
        return null;
    }
    
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }
    

    public boolean addUser(User user) {
        return userDAO.addUser(user);
    }

    public boolean deleteUser(int userId) {
        return userDAO.deleteUser(userId);
    }
}
