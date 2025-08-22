<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bills</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/lucide/0.263.1/lucide.min.css" rel="stylesheet">
    <style>

        body { font-family: system-ui; background: hsl(222.2 84% 4.9%); color: hsl(210 40% 98%); }
        .container { max-width: 1200px; margin: 0 auto; padding: 2rem; }
        .navigation-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; border-bottom: 1px solid hsl(217.2 32.6% 17.5%); padding-bottom: 1rem; }
        .breadcrumb { display: flex; gap: 0.5rem; font-size: 0.875rem; color: hsl(215 20.2% 65.1%); }
        .header h1 { font-size: 2rem; font-weight: 700; background: linear-gradient(135deg, hsl(217.2 91.2% 59.8%), #60A5FA); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .header p { color: hsl(215 20.2% 65.1%); }
        .btn { padding: 0.5rem 1rem; border-radius: 0.5rem; font-size: 0.875rem; font-weight: 500; display: inline-flex; gap: 0.5rem; align-items: center; cursor: pointer; text-decoration: none; }
        .btn-outline { border: 1px solid hsl(217.2 32.6% 17.5%); background: transparent; color: hsl(215 20.2% 65.1%); }
        .btn-outline:hover { background: hsl(217.2 32.6% 17.5%); color: white; }
        .btn-primary { background: linear-gradient(135deg, hsl(217.2 91.2% 59.8%), #60A5FA); color: white; }
        .table-container { background: hsl(222.2 84% 4.9%); border: 1px solid hsl(217.2 32.6% 17.5%); border-radius: 0.75rem; overflow: hidden; margin-top: 2rem; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 1rem; text-align: left; font-size: 0.875rem; border-bottom: 1px solid hsl(217.2 32.6% 17.5%); }
        th { background: hsl(217.2 32.6% 17.5%); color: hsl(215 20.2% 65.1%); text-transform: uppercase; font-size: 0.75rem; }
        tbody tr:hover { background: hsl(217.2 32.6% 17.5%); }
        .empty-state { text-align: center; padding: 3rem; color: hsl(215 20.2% 65.1%); }
    </style>
</head>
<body>
<div class="container">

    <!-- 🔹 Navigation -->
    <div class="navigation-bar">
        <div class="breadcrumb">
            <span>Dashboard</span>
            <span>•</span>
            <span style="color:white;">Manage Bills</span>
        </div>
        <a href="${pageContext.request.contextPath}/views/admin-dashboard.jsp" class="btn btn-outline">
            ⬅ Back to Dashboard
        </a>
    </div>

    <!-- 🔹 Header -->
    <div class="header">
        <h1>Manage Bills</h1>
        <p>View all customer bills and generate invoices</p>
    </div>

    <!-- 🔹 Bills Table -->
    <div class="table-container">
        <c:choose>
            <c:when test="${not empty bills}">
                <table>
                    <thead>
                    <tr>
                        <th>Bill ID</th>
                        <th>Customer</th>
                        <th>Date</th>
                        <th>Total Amount</th>
                        <th>Payment Method</th>
                        <th>Invoice</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="bill" items="${bills}">
  
                        <tr>
                            <td>#${bill.billId}</td>
                            <td>${bill.customer.name}</td>
                            <td>${bill.date}</td>
                            <td>Rs. ${bill.totalAmount}</td>
                            <td>${bill.paymentMethod}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/BillController?action=preview&billId=${bill.billId}"
                                   class="btn btn-primary btn-sm">
                                    View Invoice
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <h3>No bills found</h3>
                    <p>Start by adding a new bill from the billing section</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>
</body>
</html>
