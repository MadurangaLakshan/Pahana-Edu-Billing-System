package com.pahana.dao;

import com.pahana.util.DBConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {


    public double getTotalRevenue() {
        String query = "SELECT COALESCE(SUM(totalAmount), 0) as total FROM bill";
        
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }


    public double getTodayRevenue() {
        String query = "SELECT COALESCE(SUM(totalAmount), 0) as total FROM bill WHERE DATE(date) = CURDATE()";
        
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public double getWeekRevenue() {
        String query = "SELECT COALESCE(SUM(totalAmount), 0) as total FROM bill WHERE date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
        
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }


    public double getMonthRevenue() {
        String query = "SELECT COALESCE(SUM(totalAmount), 0) as total FROM bill WHERE date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
        
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public double getRevenueByDateRange(java.util.Date startDate, java.util.Date endDate) {
        String query = "SELECT COALESCE(SUM(totalAmount), 0) as total FROM bill WHERE date >= ? AND date <= ?";
        
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setTimestamp(1, new Timestamp(startDate.getTime()));
            stmt.setTimestamp(2, new Timestamp(endDate.getTime()));
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public List<TopProduct> getTopProducts(int limit) {
        List<TopProduct> topProducts = new ArrayList<>();
        String query = """
            SELECT i.name, i.itemCode, 
                   SUM(bi.quantity) as totalSold,
                   SUM(bi.quantity * bi.unitPrice) as revenue
            FROM bill_item bi
            INNER JOIN item i ON bi.itemId = i.itemId
            INNER JOIN bill b ON bi.billId = b.billId
            WHERE b.date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
            GROUP BY i.itemId, i.name, i.itemCode
            ORDER BY totalSold DESC
            LIMIT ?
        """;

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                TopProduct product = new TopProduct();
                product.setName(rs.getString("name"));
                product.setCategory(rs.getString("itemCode")); 
                product.setSoldCount(rs.getInt("totalSold"));
                product.setRevenue(rs.getDouble("revenue"));
                topProducts.add(product);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return topProducts;
    }

    public List<TopProduct> getTopProductsByRevenue(int limit) {
        List<TopProduct> topProducts = new ArrayList<>();
        String query = """
            SELECT i.name, i.itemCode, 
                   SUM(bi.quantity) as totalSold,
                   SUM(bi.quantity * bi.unitPrice) as revenue
            FROM bill_item bi
            INNER JOIN item i ON bi.itemId = i.itemId
            INNER JOIN bill b ON bi.billId = b.billId
            WHERE b.date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
            GROUP BY i.itemId, i.name, i.itemCode
            ORDER BY revenue DESC
            LIMIT ?
        """;

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                TopProduct product = new TopProduct();
                product.setName(rs.getString("name"));
                product.setCategory(rs.getString("itemCode")); 
                product.setSoldCount(rs.getInt("totalSold"));
                product.setRevenue(rs.getDouble("revenue"));
                topProducts.add(product);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return topProducts;
    }

    public List<DailyRevenue> getDailyRevenue(int days) {
        List<DailyRevenue> dailyRevenue = new ArrayList<>();
        String query = """
            SELECT DATE(date) as day, COALESCE(SUM(totalAmount), 0) as revenue
            FROM bill
            WHERE date >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
            GROUP BY DATE(date)
            ORDER BY DATE(date) ASC
        """;

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, days);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                DailyRevenue dr = new DailyRevenue();
                java.sql.Date sqlDate = rs.getDate("day");
                if (sqlDate != null) {
                    dr.setDate(new java.util.Date(sqlDate.getTime()));
                }
                dr.setRevenue(rs.getDouble("revenue"));
                dailyRevenue.add(dr);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dailyRevenue;
    }

    public List<MonthlyRevenue> getMonthlyRevenue() {
        List<MonthlyRevenue> monthlyRevenue = new ArrayList<>();
        String query = """
            SELECT YEAR(date) as year, MONTH(date) as month, 
                   MONTHNAME(date) as monthName,
                   COALESCE(SUM(totalAmount), 0) as revenue
            FROM bill
            WHERE YEAR(date) = YEAR(CURDATE())
            GROUP BY YEAR(date), MONTH(date), MONTHNAME(date)
            ORDER BY YEAR(date), MONTH(date)
        """;

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                MonthlyRevenue mr = new MonthlyRevenue();
                mr.setYear(rs.getInt("year"));
                mr.setMonth(rs.getInt("month"));
                mr.setMonthName(rs.getString("monthName"));
                mr.setRevenue(rs.getDouble("revenue"));
                monthlyRevenue.add(mr);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return monthlyRevenue;
    }

    public CustomerStats getCustomerStats() {
        CustomerStats stats = new CustomerStats();
        
        String query = """
            SELECT 
                COUNT(DISTINCT c.customerId) as totalCustomers,
                COUNT(b.billId) as totalOrders,
                AVG(b.totalAmount) as avgOrderValue
            FROM customer c
            LEFT JOIN bill b ON c.customerId = b.customerId
        """;

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                stats.setTotalCustomers(rs.getInt("totalCustomers"));
                stats.setTotalOrders(rs.getInt("totalOrders"));
                stats.setAverageOrderValue(rs.getDouble("avgOrderValue"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<PaymentMethodStats> getPaymentMethodStats() {
        List<PaymentMethodStats> paymentStats = new ArrayList<>();
        String query = """
            SELECT paymentMethod, 
                   COUNT(*) as count,
                   SUM(totalAmount) as revenue
            FROM bill
            GROUP BY paymentMethod
            ORDER BY count DESC
        """;

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                PaymentMethodStats pms = new PaymentMethodStats();
                pms.setPaymentMethod(rs.getString("paymentMethod"));
                pms.setCount(rs.getInt("count"));
                pms.setRevenue(rs.getDouble("revenue"));
                paymentStats.add(pms);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return paymentStats;
    }

    // Inner classes for report data models
    public static class TopProduct {
        private String name;
        private String category;
        private int soldCount;
        private double revenue;

     
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        
        public int getSoldCount() { return soldCount; }
        public void setSoldCount(int soldCount) { this.soldCount = soldCount; }
        
        public double getRevenue() { return revenue; }
        public void setRevenue(double revenue) { this.revenue = revenue; }
    }

    public static class DailyRevenue {
        private java.util.Date date;
        private double revenue;

        // Getters and setters
        public java.util.Date getDate() { return date; }
        public void setDate(java.util.Date date) { this.date = date; }
        
        public double getRevenue() { return revenue; }
        public void setRevenue(double revenue) { this.revenue = revenue; }
    }

    public static class MonthlyRevenue {
        private int year;
        private int month;
        private String monthName;
        private double revenue;

   
        public int getYear() { return year; }
        public void setYear(int year) { this.year = year; }
        
        public int getMonth() { return month; }
        public void setMonth(int month) { this.month = month; }
        
        public String getMonthName() { return monthName; }
        public void setMonthName(String monthName) { this.monthName = monthName; }
        
        public double getRevenue() { return revenue; }
        public void setRevenue(double revenue) { this.revenue = revenue; }
    }

    public static class CustomerStats {
        private int totalCustomers;
        private int totalOrders;
        private double averageOrderValue;

       
        public int getTotalCustomers() { return totalCustomers; }
        public void setTotalCustomers(int totalCustomers) { this.totalCustomers = totalCustomers; }
        
        public int getTotalOrders() { return totalOrders; }
        public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }
        
        public double getAverageOrderValue() { return averageOrderValue; }
        public void setAverageOrderValue(double averageOrderValue) { this.averageOrderValue = averageOrderValue; }
    }

    public static class PaymentMethodStats {
        private String paymentMethod;
        private int count;
        private double revenue;

       
        public String getPaymentMethod() { return paymentMethod; }
        public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
        
        public int getCount() { return count; }
        public void setCount(int count) { this.count = count; }
        
        public double getRevenue() { return revenue; }
        public void setRevenue(double revenue) { this.revenue = revenue; }
    }
}