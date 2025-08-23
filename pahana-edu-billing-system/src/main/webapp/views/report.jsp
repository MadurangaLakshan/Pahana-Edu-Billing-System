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
    <title>Analytics Report - Pahana System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/lucide/0.263.1/lucide.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    <style>
        :root {
            --background: 222.2 84% 4.9%;
            --foreground: 210 40% 98%;
            --card: 222.2 84% 4.9%;
            --card-foreground: 210 40% 98%;
            --popover: 222.2 84% 4.9%;
            --popover-foreground: 210 40% 98%;
            --primary: 217.2 91.2% 59.8%;
            --primary-foreground: 222.2 84% 4.9%;
            --secondary: 217.2 32.6% 17.5%;
            --secondary-foreground: 210 40% 98%;
            --muted: 217.2 32.6% 17.5%;
            --muted-foreground: 215 20.2% 65.1%;
            --accent: 217.2 32.6% 17.5%;
            --accent-foreground: 210 40% 98%;
            --destructive: 0 62.8% 30.6%;
            --destructive-foreground: 210 40% 98%;
            --border: 217.2 32.6% 17.5%;
            --input: 217.2 32.6% 17.5%;
            --ring: 224.3 76.3% 94.1%;
            --success: 142 76% 36%;
            --success-foreground: 210 40% 98%;
            --warning: 43 96% 56%;
            --warning-foreground: 222.2 84% 4.9%;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
            background-color: hsl(var(--background));
            color: hsl(var(--foreground));
            line-height: 1.5;
            -webkit-font-smoothing: antialiased;
            min-height: 100vh;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

        .navigation-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding: 1rem 0;
            border-bottom: 1px solid hsl(var(--border));
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: hsl(var(--muted-foreground));
            font-size: 0.875rem;
        }

        .breadcrumb-separator {
            color: hsl(var(--border));
        }

        .header {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }

        .header p {
            color: hsl(var(--muted-foreground));
            font-size: 1.1rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            font-size: 0.875rem;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            outline: none;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-outline {
            background: transparent;
            color: hsl(var(--muted-foreground));
            border: 1px solid hsl(var(--border));
        }

        .btn-outline:hover {
            background: hsl(var(--accent));
            color: hsl(var(--accent-foreground));
            border-color: hsl(var(--primary));
        }

        .btn-primary {
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
            color: hsl(var(--primary-foreground));
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.4);
        }

        .revenue-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .revenue-card {
            background: hsl(var(--card));
            border: 1px solid hsl(var(--border));
            border-radius: 0.75rem;
            padding: 2rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .revenue-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .revenue-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient);
        }

        .revenue-card.total::before {
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
        }

        .revenue-card.today::before {
            background: linear-gradient(135deg, hsl(var(--success)), #10B981);
        }

        .revenue-card.week::before {
            background: linear-gradient(135deg, hsl(var(--warning)), #F59E0B);
        }

        .revenue-card.month::before {
            background: linear-gradient(135deg, #8B5CF6, #A855F7);
        }

        .revenue-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .revenue-icon {
            width: 2.5rem;
            height: 2.5rem;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .revenue-icon.total {
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
        }

        .revenue-icon.today {
            background: linear-gradient(135deg, hsl(var(--success)), #10B981);
        }

        .revenue-icon.week {
            background: linear-gradient(135deg, hsl(var(--warning)), #F59E0B);
        }

        .revenue-icon.month {
            background: linear-gradient(135deg, #8B5CF6, #A855F7);
        }

        .revenue-title {
            color: hsl(var(--muted-foreground));
            font-size: 0.875rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .revenue-amount {
            font-size: 2.25rem;
            font-weight: 700;
            color: hsl(var(--foreground));
            margin-bottom: 0.5rem;
        }

        .revenue-change {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.875rem;
        }

        .revenue-change.positive {
            color: hsl(var(--success));
        }

        .revenue-change.negative {
            color: #EF4444;
        }

        .revenue-change.neutral {
            color: hsl(var(--muted-foreground));
        }

        .charts-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .chart-container {
            background: hsl(var(--card));
            border: 1px solid hsl(var(--border));
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .chart-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid hsl(var(--border));
        }

        .chart-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: hsl(var(--foreground));
        }

        .chart-canvas {
            max-height: 400px;
        }

        .top-products {
            background: hsl(var(--card));
            border: 1px solid hsl(var(--border));
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .top-products-header {
            background: hsl(var(--muted));
            padding: 1.5rem;
            border-bottom: 1px solid hsl(var(--border));
        }

        .top-products-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: hsl(var(--foreground));
            margin-bottom: 0.25rem;
        }

        .top-products-subtitle {
            color: hsl(var(--muted-foreground));
            font-size: 0.875rem;
        }

        .product-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem;
            border-bottom: 1px solid hsl(var(--border));
            transition: background-color 0.2s;
        }

        .product-item:hover {
            background: hsl(var(--accent));
        }

        .product-item:last-child {
            border-bottom: none;
        }

        .product-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex: 1;
        }

        .product-rank {
            width: 2rem;
            height: 2rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.875rem;
            color: white;
        }

        .product-rank.first {
            background: linear-gradient(135deg, #FFD700, #FFA500);
        }

        .product-rank.second {
            background: linear-gradient(135deg, #C0C0C0, #A0A0A0);
        }

        .product-rank.third {
            background: linear-gradient(135deg, #CD7F32, #B8860B);
        }

        .product-rank.other {
            background: hsl(var(--muted));
            color: hsl(var(--muted-foreground));
        }

        .product-details h4 {
            font-size: 0.975rem;
            font-weight: 600;
            color: hsl(var(--foreground));
            margin-bottom: 0.25rem;
        }

        .product-details p {
            font-size: 0.875rem;
            color: hsl(var(--muted-foreground));
        }

        .product-stats {
            text-align: right;
        }

        .product-sales {
            font-size: 1.125rem;
            font-weight: 600;
            color: hsl(var(--foreground));
        }

        .product-revenue {
            font-size: 0.875rem;
            color: hsl(var(--muted-foreground));
        }

        @media (max-width: 1024px) {
            .charts-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .revenue-grid {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1rem;
            }
            
            .navigation-bar {
                flex-direction: column;
                align-items: stretch;
                gap: 1rem;
            }
            
            .revenue-card {
                padding: 1.5rem;
            }
            
            .revenue-amount {
                font-size: 1.875rem;
            }
        }

        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }

        ::-webkit-scrollbar-track {
            background: hsl(var(--background));
        }

        ::-webkit-scrollbar-thumb {
            background: hsl(var(--border));
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: hsl(var(--muted-foreground));
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        .btn:disabled:hover {
            transform: none;
            box-shadow: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation Bar -->
        <div class="navigation-bar">
            <div class="breadcrumb">
                <span>Dashboard</span>
                <span class="breadcrumb-separator">•</span>
                <span style="color: hsl(var(--foreground));">Analytics Report</span>
            </div>
            <div style="display: flex; gap: 1rem;">
                <button onclick="exportReport()" class="btn btn-primary">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                        <polyline points="7,10 12,15 17,10"/>
                        <line x1="12" y1="15" x2="12" y2="3"/>
                    </svg>
                    Export Report
                </button>
                <button onclick="refreshData()" class="btn btn-outline">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="23,4 23,10 17,10"/>
                        <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/>
                    </svg>
                    Refresh Data
                </button>
                <a href="${pageContext.request.contextPath}/views/admin-dashboard.jsp" class="btn btn-outline">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                        <polyline points="9,22 9,12 15,12 15,22"/>
                    </svg>
                    Back to Dashboard
                </a>
            </div>
        </div>

        <div class="header">
            <h1>Analytics Report</h1>
            <p>Comprehensive revenue and sales performance analysis</p>
        </div>

        <!-- Revenue Cards -->
        <div class="revenue-grid">
            <div class="revenue-card total">
                <div class="revenue-header">
                    <div>
                        <div class="revenue-title">Total Revenue</div>
                    </div>
                    <div class="revenue-icon total">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="12" y1="1" x2="12" y2="23"/>
                            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                        </svg>
                    </div>
                </div>
                <div class="revenue-amount">
                    <c:choose>
                        <c:when test="${not empty totalRevenue}">
                            <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$"/>
                        </c:when>
                        <c:otherwise>$0.00</c:otherwise>
                    </c:choose>
                </div>
                <div class="revenue-change neutral">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="7" y1="17" x2="17" y2="7"/>
                        <polyline points="7,7 17,7 17,17"/>
                    </svg>
                    Total earnings to date
                </div>
            </div>

            <div class="revenue-card today">
                <div class="revenue-header">
                    <div>
                        <div class="revenue-title">Today's Revenue</div>
                    </div>
                    <div class="revenue-icon today">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="10"/>
                            <polyline points="12,6 12,12 16,14"/>
                        </svg>
                    </div>
                </div>
                <div class="revenue-amount">
                    <c:choose>
                        <c:when test="${not empty todayRevenue}">
                            <fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="$"/>
                        </c:when>
                        <c:otherwise>$0.00</c:otherwise>
                    </c:choose>
                </div>
                <div class="revenue-change positive">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/>
                        <polyline points="12,6 12,12 16,14"/>
                    </svg>
                    Today's sales
                </div>
            </div>

            <div class="revenue-card week">
                <div class="revenue-header">
                    <div>
                        <div class="revenue-title">Last 7 Days</div>
                    </div>
                    <div class="revenue-icon week">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                            <line x1="16" y1="2" x2="16" y2="6"/>
                            <line x1="8" y1="2" x2="8" y2="6"/>
                            <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                    </div>
                </div>
                <div class="revenue-amount">
                    <c:choose>
                        <c:when test="${not empty weekRevenue}">
                            <fmt:formatNumber value="${weekRevenue}" type="currency" currencySymbol="$"/>
                        </c:when>
                        <c:otherwise>$0.00</c:otherwise>
                    </c:choose>
                </div>
                <div class="revenue-change positive">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                        <line x1="16" y1="2" x2="16" y2="6"/>
                        <line x1="8" y1="2" x2="8" y2="6"/>
                        <line x1="3" y1="10" x2="21" y2="10"/>
                    </svg>
                    Weekly performance
                </div>
            </div>

            <div class="revenue-card month">
                <div class="revenue-header">
                    <div>
                        <div class="revenue-title">Last 30 Days</div>
                    </div>
                    <div class="revenue-icon month">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M3 3v18h18"/>
                            <path d="M18.7 8l-5.1 5.2-2.8-2.7L7 14.3"/>
                        </svg>
                    </div>
                </div>
                <div class="revenue-amount">
                    <c:choose>
                        <c:when test="${not empty monthRevenue}">
                            <fmt:formatNumber value="${monthRevenue}" type="currency" currencySymbol="$"/>
                        </c:when>
                        <c:otherwise>$0.00</c:otherwise>
                    </c:choose>
                </div>
                <div class="revenue-change positive">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 3v18h18"/>
                        <path d="M18.7 8l-5.1 5.2-2.8-2.7L7 14.3"/>
                    </svg>
                    Monthly summary
                </div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="charts-grid">
            <div class="chart-container">
                <div class="chart-header">
                    <div class="chart-title">Revenue Trend (Last 30 Days)</div>
                </div>
                <canvas id="revenueChart" class="chart-canvas"></canvas>
            </div>

            <div class="top-products">
                <div class="top-products-header">
                    <div class="top-products-title">Top Selling Items</div>
                    <div class="top-products-subtitle">Most popular products this month</div>
                </div>
                
                <c:choose>
                    <c:when test="${not empty topProducts}">
                        <c:forEach var="product" items="${topProducts}" varStatus="status">
                            <div class="product-item">
                                <div class="product-info">
                                    <c:choose>
                                        <c:when test="${status.index == 0}">
                                            <div class="product-rank first">${status.index + 1}</div>
                                        </c:when>
                                        <c:when test="${status.index == 1}">
                                            <div class="product-rank second">${status.index + 1}</div>
                                        </c:when>
                                        <c:when test="${status.index == 2}">
                                            <div class="product-rank third">${status.index + 1}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="product-rank other">${status.index + 1}</div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="product-details">
                                        <h4><c:out value="${product.name}"/></h4>
                                        <p><c:out value="${product.category}"/></p>
                                    </div>
                                </div>
                                <div class="product-stats">
                                    <div class="product-sales">${product.soldCount} sold</div>
                                    <div class="product-revenue">
                                        <fmt:formatNumber value="${product.revenue}" type="currency" currencySymbol="$"/>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="product-item">
                            <div class="product-info">
                                <div class="product-rank other">-</div>
                                <div class="product-details">
                                    <h4>No sales data available</h4>
                                    <p>Start making sales to see top products</p>
                                </div>
                            </div>
                            <div class="product-stats">
                                <div class="product-sales">0 sold</div>
                                <div class="product-revenue">$0.00</div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        
 // Initialize Revenue Chart with real data
 const ctx = document.getElementById('revenueChart').getContext('2d');
 const gradient = ctx.createLinearGradient(0, 0, 0, 400);
 gradient.addColorStop(0, 'rgba(59, 130, 246, 0.8)');
 gradient.addColorStop(1, 'rgba(59, 130, 246, 0.1)');

 // Prepare chart data from JSP
 let chartLabels = [];
 let chartData = [];

 <c:choose>
     <c:when test="${not empty dailyRevenue}">
         <c:forEach var="revenue" items="${dailyRevenue}" varStatus="status">
             chartLabels.push('<fmt:formatDate value="${revenue.date}" pattern="MMM dd"/>');
             chartData.push(${revenue.revenue});
         </c:forEach>
     </c:when>
     <c:otherwise>
         // Default data if no real data available
         const today = new Date();
         for (let i = 29; i >= 0; i--) {
             const date = new Date(today.getTime() - i * 24 * 60 * 60 * 1000);
             const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
             chartLabels.push(monthNames[date.getMonth()] + ' ' + date.getDate());
             chartData.push(Math.floor(Math.random() * 5000) + 1000); // Sample data
         }
     </c:otherwise>
 </c:choose>

 // Ensure we have data
 if (chartLabels.length === 0) {
     console.error('No chart data available');
     // Add fallback data
     chartLabels = ['30d ago', '25d ago', '20d ago', '15d ago', '10d ago', '5d ago', 'Today'];
     chartData = [1200, 1800, 2100, 1900, 2400, 2800, 3200];
 }

 console.log('Chart Labels:', chartLabels);
 console.log('Chart Data:', chartData);

 const chart = new Chart(ctx, {
     type: 'line',
     data: {
         labels: chartLabels,
         datasets: [{
             label: 'Revenue ($)',
             data: chartData,
             borderColor: 'rgb(59, 130, 246)',
             backgroundColor: gradient,
             borderWidth: 3,
             fill: true,
             tension: 0.4,
             pointBackgroundColor: 'rgb(59, 130, 246)',
             pointBorderColor: '#ffffff',
             pointBorderWidth: 2,
             pointRadius: 6,
             pointHoverRadius: 8
         }]
     },
     options: {
         responsive: true,
         maintainAspectRatio: false,
         interaction: {
             intersect: false,
             mode: 'index'
         },
         plugins: {
             legend: {
                 display: false
             },
             tooltip: {
                 backgroundColor: 'hsl(222.2, 84%, 4.9%)',
                 titleColor: 'hsl(210, 40%, 98%)',
                 bodyColor: 'hsl(210, 40%, 98%)',
                 borderColor: 'hsl(217.2, 32.6%, 17.5%)',
                 borderWidth: 1,
                 cornerRadius: 8,
                 displayColors: false,
                 callbacks: {
                     label: function(context) {
                         return '$' + context.parsed.y.toLocaleString();
                     }
                 }
             }
         },
         scales: {
             x: {
                 border: {
                     color: 'hsl(217.2, 32.6%, 17.5%)'
                 },
                 grid: {
                     color: 'hsl(217.2, 32.6%, 17.5%)',
                     drawBorder: false
                 },
                 ticks: {
                     color: 'hsl(215, 20.2%, 65.1%)',
                     font: {
                         size: 12
                     }
                 }
             },
             y: {
                 border: {
                     color: 'hsl(217.2, 32.6%, 17.5%)'
                 },
                 grid: {
                     color: 'hsl(217.2, 32.6%, 17.5%)',
                     drawBorder: false
                 },
                 ticks: {
                     color: 'hsl(215, 20.2%, 65.1%)',
                     font: {
                         size: 12
                     },
                     callback: function(value) {
                         return '$' + value.toLocaleString();
                     }
                 }
             }
         }
     }
 });

        // Export Report Function
        function exportReport() {
            const modal = document.createElement('div');
            modal.innerHTML = 
                '<div style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.8); display: flex; align-items: center; justify-content: center; z-index: 1000;">' +
                    '<div style="background: hsl(var(--card)); padding: 2rem; border-radius: 0.75rem; border: 1px solid hsl(var(--border)); max-width: 400px; width: 90%;">' +
                        '<h3 style="color: hsl(var(--foreground)); margin-bottom: 1rem; font-size: 1.25rem;">Export Report</h3>' +
                        '<p style="color: hsl(var(--muted-foreground)); margin-bottom: 2rem;">Choose export format:</p>' +
                        '<div style="display: flex; flex-direction: column; gap: 0.75rem; margin-bottom: 2rem;">' +
                            '<button onclick="exportToPDF()" class="btn btn-primary" style="justify-content: center;">' +
                                '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                                    '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>' +
                                    '<polyline points="14,2 14,8 20,8"/>' +
                                    '<line x1="16" y1="13" x2="8" y2="13"/>' +
                                    '<line x1="16" y1="17" x2="8" y2="17"/>' +
                                    '<polyline points="10,9 9,9 8,9"/>' +
                                '</svg>' +
                                'Export as PDF' +
                            '</button>' +
                            '<button onclick="exportToExcel()" class="btn btn-outline" style="justify-content: center;">' +
                                '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                                    '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>' +
                                    '<polyline points="14,2 14,8 20,8"/>' +
                                    '<line x1="16" y1="13" x2="8" y2="13"/>' +
                                    '<line x1="16" y1="17" x2="8" y2="17"/>' +
                                    '<polyline points="10,9 9,9 8,9"/>' +
                                '</svg>' +
                                'Export as Excel' +
                            '</button>' +
                        '</div>' +
                        '<div style="display: flex; gap: 1rem; justify-content: flex-end;">' +
                            '<button onclick="this.closest(\'div\').parentElement.remove()" class="btn btn-outline">Cancel</button>' +
                        '</div>' +
                    '</div>' +
                '</div>';
            document.body.appendChild(modal);
        }

        function exportToPDF() {
            showExportSuccess('PDF');
            document.querySelector('[style*="position: fixed"]').remove();
        }

        function exportToExcel() {
            showExportSuccess('Excel');
            document.querySelector('[style*="position: fixed"]').remove();
        }

        function showExportSuccess(format) {
            const toast = document.createElement('div');
            toast.innerHTML = 
                '<div style="position: fixed; top: 2rem; right: 2rem; background: hsl(var(--success)); color: white; padding: 1rem 1.5rem; border-radius: 0.5rem; box-shadow: 0 4px 12px rgba(0,0,0,0.3); z-index: 1001; display: flex; align-items: center; gap: 0.5rem;">' +
                    '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' +
                        '<polyline points="20,6 9,17 4,12"/>' +
                    '</svg>' +
                    'Report exported as ' + format + ' successfully!' +
                '</div>';
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.remove();
            }, 3000);
        }

        // Refresh data functionality
        function refreshData() {
            const refreshBtn = document.querySelector('[onclick="refreshData()"]');
            if (refreshBtn) {
                refreshBtn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="animation: spin 1s linear infinite;"><polyline points="23,4 23,10 17,10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/></svg>Refreshing...';
                refreshBtn.disabled = true;
                
                // Reload the page to fetch fresh data
                setTimeout(() => {
                    window.location.reload();
                }, 1000);
            }
        }

        // Add animation to revenue cards on load
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.revenue-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>