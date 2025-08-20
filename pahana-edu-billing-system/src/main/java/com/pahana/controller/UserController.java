
package com.pahana.controller;

import com.pahana.model.User;
import com.pahana.service.UserService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class UserController extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = UserService.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.equals("login")) {
            handleLogin(request, response);
        } else if (action.equals("save")) {
            handleSave(request, response);
        } else {
            response.sendRedirect("views/login.jsp?error=Invalid action");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.equals("logout")) {
            handleLogout(request, response);
        } else if (action.equals("list")) {
            handleList(request, response);
        } else if (action.equals("add")) {
            request.getRequestDispatcher("views/user-form.jsp").forward(request, response);
        } else if (action.equals("delete")) {
            handleDelete(request, response);
        } else {
            response.sendRedirect("views/login.jsp?error=Unknown action");
        }
    }

    /** ------------------- LOGIN ------------------- */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userService.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);

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

    /** ------------------- LOGOUT ------------------- */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("views/login.jsp?message=Logged out successfully");
    }

    /** ------------------- LIST USERS ------------------- */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("views/manage-users.jsp").forward(request, response);
    }

    /** ------------------- ADD/EDIT USER ------------------- */
    private void handleSave(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String userIdStr = request.getParameter("userId");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (userIdStr == null || userIdStr.isEmpty()) {
           
            User newUser = new User(username, password, role);

            userService.addUser(newUser);
        } 

        response.sendRedirect("UserController?action=list");
    }


    /** ------------------- DELETE USER ------------------- */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null) {
            int userId = Integer.parseInt(userIdStr);
            userService.deleteUser(userId);
        }
        response.sendRedirect("UserController?action=list");
    }
}

