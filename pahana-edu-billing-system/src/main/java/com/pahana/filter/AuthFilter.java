package com.pahana.filter;

import com.pahana.model.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        String path = req.getRequestURI();
        
        if (path.endsWith("login.jsp") || path.endsWith("UserController")) {
            chain.doFilter(request, response);
            return;
        }

        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            // Not logged in → always send to login
        	res.sendRedirect(req.getContextPath() + "/views/login.jsp?error=unauthorized");
            return;
        }

        // Role-based access control
        if (path.contains("admin-dashboard.jsp") && !"Admin".equals(loggedUser.getRole())) {
            res.sendRedirect(req.getContextPath() + "/views/staff-dashboard.jsp");
            return;
        }

        if (path.contains("staff-dashboard.jsp") && !"Staff".equals(loggedUser.getRole())) {
            res.sendRedirect(req.getContextPath() + "/views/admin-dashboard.jsp");
            return;
        }

        // Otherwise, allow request
        chain.doFilter(request, response);
    }
}
