package com.pahana.controller;

import com.pahana.dao.ReportDAO;
import com.pahana.dao.ReportDAO.*;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AnalyticsController extends HttpServlet {
    private ReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("report".equals(action)) {
            // Get revenue analytics
            double totalRevenue = reportDAO.getTotalRevenue();
            double todayRevenue = reportDAO.getTodayRevenue();
            double weekRevenue = reportDAO.getWeekRevenue();
            double monthRevenue = reportDAO.getMonthRevenue();

            // Get product analytics
            List<TopProduct> topProducts = reportDAO.getTopProducts(5);
            List<TopProduct> topProductsByRevenue = reportDAO.getTopProductsByRevenue(5);

            // Get chart data
            List<DailyRevenue> dailyRevenue = reportDAO.getDailyRevenue(30);
            List<MonthlyRevenue> monthlyRevenue = reportDAO.getMonthlyRevenue();

            // Get customer and payment stats
            CustomerStats customerStats = reportDAO.getCustomerStats();
            List<PaymentMethodStats> paymentStats = reportDAO.getPaymentMethodStats();

            // Set attributes for JSP
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("todayRevenue", todayRevenue);
            request.setAttribute("weekRevenue", weekRevenue);
            request.setAttribute("monthRevenue", monthRevenue);
            
            request.setAttribute("topProducts", topProducts);
            request.setAttribute("topProductsByRevenue", topProductsByRevenue);
            
            request.setAttribute("dailyRevenue", dailyRevenue);
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            
            request.setAttribute("customerStats", customerStats);
            request.setAttribute("paymentStats", paymentStats);

            // Forward to analytics report JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("views/report.jsp");
            dispatcher.forward(request, response);

        } else if ("dashboard".equals(action)) {
            // Lightweight dashboard data
            double totalRevenue = reportDAO.getTotalRevenue();
            double todayRevenue = reportDAO.getTodayRevenue();
            double weekRevenue = reportDAO.getWeekRevenue();
            double monthRevenue = reportDAO.getMonthRevenue();
            
            List<TopProduct> topProducts = reportDAO.getTopProducts(3);
            CustomerStats customerStats = reportDAO.getCustomerStats();

            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("todayRevenue", todayRevenue);
            request.setAttribute("weekRevenue", weekRevenue);
            request.setAttribute("monthRevenue", monthRevenue);
            request.setAttribute("topProducts", topProducts);
            request.setAttribute("customerStats", customerStats);

            RequestDispatcher dispatcher = request.getRequestDispatcher("views/admin-dashboard.jsp");
            dispatcher.forward(request, response);

        } else {
            // Default redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/analytics?action=dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests for custom date range filtering
        String action = request.getParameter("action");
        
        if ("customRange".equals(action)) {

            response.sendRedirect(request.getContextPath() + "/analytics?action=report");
        } else {
            doGet(request, response);
        }
    }
}