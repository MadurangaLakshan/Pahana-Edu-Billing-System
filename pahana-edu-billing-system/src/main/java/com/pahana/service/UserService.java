package com.pahana.service;

import com.pahana.dao.UserDAO;
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
}
