package com.pahana.controller;

import com.pahana.model.User;
import com.pahana.service.UserService;


import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class UserController extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = UserService.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userService.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);

            // Redirect based on role
            switch (user.getRole()) {
                case "Admin":
                    response.sendRedirect("views/admin-dashboard.jsp");
                    break;
                case "Staff":
                    response.sendRedirect("views/staff-dashboard.jsp");
                    break;
                default:
                    response.sendRedirect("views/login.jsp?error=Unknown role");
            }

        } else {
            response.sendRedirect("views/login.jsp?error=Invalid credentials");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // false = don’t create if doesn’t exist
        if (session != null) {
            session.invalidate(); // remove all session attributes
        }

        // Redirect to login page with a message
        response.sendRedirect("views/login.jsp?message=Logged out successfully");
    }
}
