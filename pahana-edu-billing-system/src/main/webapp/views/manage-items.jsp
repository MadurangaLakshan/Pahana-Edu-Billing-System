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
    <title>Item Management</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/lucide/0.263.1/lucide.min.css" rel="stylesheet">
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

        .actions-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
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

        .btn-secondary {
            background: hsl(var(--secondary));
            color: hsl(var(--secondary-foreground));
            border: 1px solid hsl(var(--border));
        }

        .btn-secondary:hover {
            background: hsl(var(--accent));
            transform: translateY(-1px);
        }

        .btn-destructive {
            background: linear-gradient(135deg, hsl(var(--destructive)), #DC2626);
            color: hsl(var(--destructive-foreground));
        }

        .btn-destructive:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(220, 38, 38, 0.4);
        }

        .btn-ghost {
            background: transparent;
            color: hsl(var(--muted-foreground));
            border: 1px solid transparent;
        }

        .btn-ghost:hover {
            background: hsl(var(--accent));
            color: hsl(var(--accent-foreground));
            border-color: hsl(var(--border));
        }

        .stats-card {
            background: hsl(var(--card));
            border: 1px solid hsl(var(--border));
            border-radius: 0.75rem;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .stats-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .stats-icon {
            width: 3rem;
            height: 3rem;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .stats-icon.total {
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
        }

        .stats-icon.low-stock {
            background: linear-gradient(135deg, hsl(var(--warning)), #F59E0B);
        }

        .stats-icon.categories {
            background: linear-gradient(135deg, hsl(var(--success)), #10B981);
        }

        .stats-icon.value {
            background: linear-gradient(135deg, #8B5CF6, #A855F7);
        }

        .stats-content h3 {
            font-size: 2rem;
            font-weight: 700;
            color: hsl(var(--foreground));
        }

        .stats-content p {
            color: hsl(var(--muted-foreground));
            font-size: 0.875rem;
        }

        .table-container {
            background: hsl(var(--card));
            border: 1px solid hsl(var(--border));
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .table-header {
            background: hsl(var(--muted));
            padding: 1rem 1.5rem;
            border-bottom: 1px solid hsl(var(--border));
        }

        .table-header h2 {
            font-size: 1.25rem;
            font-weight: 600;
            color: hsl(var(--foreground));
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 1rem 1.5rem;
            text-align: left;
            font-size: 0.875rem;
        }

        th {
            background: hsl(var(--muted));
            color: hsl(var(--muted-foreground));
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.025em;
            font-size: 0.75rem;
        }

        tbody tr {
            border-bottom: 1px solid hsl(var(--border));
            transition: background-color 0.2s;
        }

        tbody tr:hover {
            background: hsl(var(--accent));
        }

        tbody tr:last-child {
            border-bottom: none;
        }

        .item-code {
            font-family: 'Courier New', monospace;
            font-weight: 600;
            color: hsl(var(--primary));
            background: hsl(var(--accent));
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
        }

        .price-display {
            font-weight: 600;
            color: hsl(var(--success));
            font-size: 0.875rem;
        }

        .stock-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 0.375rem;
            font-size: 0.75rem;
            font-weight: 500;
            text-align: center;
            min-width: 80px;
        }

        .stock-high {
            background: rgba(34, 197, 94, 0.1);
            color: hsl(var(--success));
            border: 1px solid rgba(34, 197, 94, 0.2);
        }

        .stock-medium {
            background: rgba(251, 191, 36, 0.1);
            color: hsl(var(--warning));
            border: 1px solid rgba(251, 191, 36, 0.2);
        }

        .stock-low {
            background: rgba(239, 68, 68, 0.1);
            color: #EF4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .category-tag {
            background: hsl(var(--accent));
            color: hsl(var(--accent-foreground));
            padding: 0.25rem 0.75rem;
            border-radius: 0.375rem;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .btn-sm {
            padding: 0.5rem 0.75rem;
            font-size: 0.75rem;
            border-radius: 0.375rem;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: hsl(var(--muted-foreground));
        }

        .empty-state-icon {
            width: 4rem;
            height: 4rem;
            margin: 0 auto 1rem;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
            color: hsl(var(--foreground));
        }

        .empty-state p {
            margin-bottom: 2rem;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .actions-bar {
                flex-direction: column;
                align-items: stretch;
            }
            
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }
            
            .table-container {
                overflow-x: auto;
            }
            
            table {
                min-width: 800px;
            }
            
            .navigation-bar {
                flex-direction: column;
                align-items: stretch;
                gap: 1rem;
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
    </style>
    <script>
        function confirmDelete(itemName, itemId) {
            const contextPath = '${pageContext.request.contextPath}';
            console.log('confirmDelete called with:', { itemName, itemId, contextPath });
            
            if (!itemId) {
                console.error('Item ID is missing or empty');
                alert('Error: Item ID is missing');
                return;
            }
            
            const modal = document.createElement('div');
            modal.innerHTML = 
                '<div style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.8); display: flex; align-items: center; justify-content: center; z-index: 1000;">' +
                    '<div style="background: hsl(var(--card)); padding: 2rem; border-radius: 0.75rem; border: 1px solid hsl(var(--border)); max-width: 400px; width: 90%;">' +
                        '<h3 style="color: hsl(var(--foreground)); margin-bottom: 1rem; font-size: 1.25rem;">Confirm Deletion</h3>' +
                        '<p style="color: hsl(var(--muted-foreground)); margin-bottom: 2rem;">Are you sure you want to delete item <strong style="color: hsl(var(--foreground));">"' + itemName + '"</strong>? This action cannot be undone.</p>' +
                        '<div style="display: flex; gap: 1rem; justify-content: flex-end;">' +
                            '<button onclick="this.closest(\'div\').parentElement.remove()" class="btn btn-secondary">Cancel</button>' +
                            '<button onclick="window.location.href=\'' + contextPath + '/ItemController?action=delete&itemId=' + itemId + '\'" class="btn btn-destructive">Delete</button>' +
                        '</div>' +
                    '</div>' +
                '</div>';
            document.body.appendChild(modal);
        }

        function getStockStatus(quantity) {
            if (quantity > 50) return { class: 'stock-high', text: 'In Stock' };
            if (quantity > 10) return { class: 'stock-medium', text: 'Low Stock' };
            return { class: 'stock-low', text: 'Critical' };
        }
    </script>
</head>
<body>
    <div class="container">
    	<div class="navigation-bar">
            <div class="breadcrumb">
                <span>Dashboard</span>
                <span class="breadcrumb-separator">•</span>
                <span style="color: hsl(var(--foreground));">Item Management</span>
            </div>
            <a href="${pageContext.request.contextPath}/views/admin-dashboard.jsp" class="btn btn-outline">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                    <polyline points="9,22 9,12 15,12 15,22"/>
                </svg>
                Back to Dashboard
            </a>
        </div>
        <div class="header">
            <h1>Item Management</h1>
            <p>Manage your inventory with precision and control</p>
        </div>

        <c:if test="${not empty items}">
            <div class="stats-grid">
                <div class="stats-card">
                    <div class="stats-icon total">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 7h-9"/>
                            <path d="M14 17H5"/>
                            <circle cx="17" cy="17" r="3"/>
                            <circle cx="7" cy="7" r="3"/>
                        </svg>
                    </div>
                    <div class="stats-content">
                        <h3>${items.size()}</h3>
                        <p>Total Items</p>
                    </div>
                </div>

                <div class="stats-card">
                    <div class="stats-icon low-stock">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="m12 8-9.04 9.06a2.82 2.82 0 1 0 3.98 3.98L16 12"/>
                            <circle cx="17" cy="7" r="5"/>
                        </svg>
                    </div>
                    <div class="stats-content">
                        <h3>
                            <c:set var="lowStockCount" value="0"/>
                            <c:forEach var="item" items="${items}">
                                <c:if test="${item.stockQuantity <= 10}">
                                    <c:set var="lowStockCount" value="${lowStockCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${lowStockCount}
                        </h3>
                        <p>Low Stock Alert</p>
                    </div>
                </div>

                <div class="stats-card">
                    <div class="stats-icon categories">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="3" width="7" height="7"/>
                            <rect x="14" y="3" width="7" height="7"/>
                            <rect x="14" y="14" width="7" height="7"/>
                            <rect x="3" y="14" width="7" height="7"/>
                        </svg>
                    </div>
                    <div class="stats-content">
                        <h3>
                            <!-- Fixed: Create a comma-separated list of unique categories -->
                            <c:set var="categoryList" value=""/>
                            <c:forEach var="item" items="${items}" varStatus="status">
                                <c:if test="${!fn:contains(categoryList, item.category)}">
                                    <c:set var="categoryList" value="${categoryList}${item.category},"/>
                                </c:if>
                            </c:forEach>
                            <!-- Count the commas to get unique category count -->
                            <c:set var="categoryCount" value="${fn:length(fn:split(categoryList, ',')) - 1}"/>
                            ${categoryCount > 0 ? categoryCount : 0}
                        </h3>
                        <p>Categories</p>
                    </div>
                </div>

                <div class="stats-card">
                    <div class="stats-icon value">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="12" y1="1" x2="12" y2="23"/>
                            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                        </svg>
                    </div>
                    <div class="stats-content">
                        <h3>
                            <c:set var="totalValue" value="0"/>
                            <c:forEach var="item" items="${items}">
                                <c:set var="totalValue" value="${totalValue + (item.price * item.stockQuantity)}"/>
                            </c:forEach>
                            <fmt:formatNumber value="${totalValue}" type="currency"/>
                        </h3>
                        <p>Total Value</p>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="actions-bar">
            <c:if test="${not empty items}">
                <div style="display: flex; gap: 1rem; align-items: center;">
                    <span style="color: hsl(var(--muted-foreground)); font-size: 0.875rem;">
                        Showing ${items.size()} items
                    </span>
                </div>
            </c:if>
            
            <a href="${pageContext.request.contextPath}/views/item-form.jsp" class="btn btn-primary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M5 12h14"/>
                    <path d="M12 5v14"/>
                </svg>
                Add New Item
            </a>
        </div>

        <div class="table-container">
            <c:choose>
                <c:when test="${not empty items}">
                    <div class="table-header">
                        <h2>Inventory Overview</h2>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>Item Code</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${items}">
                                <tr>
                                    <td>
                                        <span class="item-code">${item.itemCode}</span>
                                    </td>
                                    <td>
                                        <div style="font-weight: 500; color: hsl(var(--foreground));">
                                            ${item.name}
                                        </div>
                                    </td>
                                    <td>
                                        <div style="color: hsl(var(--muted-foreground)); font-size: 0.875rem; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${item.description}">
                                            ${item.description}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="category-tag">${item.category}</span>
                                    </td>
                                    <td>
                                        <span class="price-display">
                                            <fmt:formatNumber value="${item.price}" type="currency"/>
                                        </span>
                                    </td>
                                    <td>
                                        <div style="font-weight: 600; font-size: 0.875rem;">
                                            ${item.stockQuantity}
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.stockQuantity > 50}">
                                                <span class="stock-badge stock-high">In Stock</span>
                                            </c:when>
                                            <c:when test="${item.stockQuantity > 10}">
                                                <span class="stock-badge stock-medium">Low Stock</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="stock-badge stock-low">Critical</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/ItemController?action=view&id=${item.itemId}" 
                                               class="btn btn-ghost btn-sm" title="View Details">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                                    <circle cx="12" cy="12" r="3"/>
                                                </svg>
                                                View
                                            </a>
                                            <a href="${pageContext.request.contextPath}/ItemController?action=edit&itemId=${item.itemId}" 
                                               class="btn btn-secondary btn-sm" title="Edit Item">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                                                    <path d="m18.5 2.5 3 3L16 11l-4 1 1-4 5.5-5.5z"/>
                                                </svg>
                                                Edit
                                            </a>
                                            <button onclick="confirmDelete('${item.name}', ${item.itemId})" 
                                                    class="btn btn-destructive btn-sm" title="Delete Item">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <polyline points="3,6 5,6 21,6"/>
                                                    <path d="m19,6v14a2,2 0 0,1-2,2H7a2,2 0 0,1-2-2V6m3,0V4a2,2 0 0,1,2-2h4a2,2 0 0,1,2,2v2"/>
                                                    <line x1="10" y1="11" x2="10" y2="17"/>
                                                    <line x1="14" y1="11" x2="14" y2="17"/>
                                                </svg>
                                                Delete
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 7h-9"/>
                                <path d="M14 17H5"/>
                                <circle cx="17" cy="17" r="3"/>
                                <circle cx="7" cy="7" r="3"/>
                            </svg>
                        </div>
                        <h3>No items found</h3>
                        <p>Start building your inventory by adding your first item</p>
                        <a href="${pageContext.request.contextPath}/views/item-form.jsp" class="btn btn-primary">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M5 12h14"/>
                                <path d="M12 5v14"/>
                            </svg>
                            Add First Item
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>