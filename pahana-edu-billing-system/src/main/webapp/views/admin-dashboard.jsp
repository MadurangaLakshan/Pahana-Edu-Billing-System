<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/lucide/0.263.1/lucide.min.css" rel="stylesheet">
    <style>
        :root {
            --background: 222.2 84% 4.9%;
            --foreground: 210 40% 98%;
            --card: 222.2 84% 4.9%;
            --primary: 217.2 91.2% 59.8%;
            --primary-foreground: 222.2 84% 4.9%;
            --muted: 217.2 32.6% 17.5%;
            --muted-foreground: 215 20.2% 65.1%;
            --border: 217.2 32.6% 17.5%;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: hsl(var(--background));
            color: hsl(var(--foreground));
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header p {
            color: hsl(var(--muted-foreground));
            margin-top: 0.5rem;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .card {
            background: hsl(var(--card));
            border: 1px solid hsl(var(--border));
            border-radius: 1rem;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.4);
        }

        .card-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: hsl(var(--primary));
        }

        .card h2 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
        }

        .card p {
            font-size: 0.9rem;
            color: hsl(var(--muted-foreground));
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .logout-btn {
            margin-top: 3rem;
            display: inline-block;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            font-weight: 600;
            transition: all 0.2s;
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(239, 68, 68, 0.4);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Admin Dashboard</h1>
            <p>Welcome, <strong>${sessionScope.loggedUser.username}</strong> (Role: ${sessionScope.loggedUser.role})</p>
        </div>

        <div class="grid">
            <a href="${pageContext.request.contextPath}/UserController?action=list">
                <div class="card">
                    <div class="card-icon">👥</div>
                    <h2>Manage Users</h2>
                    <p>Add, edit, and manage system users</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/ItemController?action=list">
                <div class="card">
                    <div class="card-icon">📦</div>
                    <h2>Manage Items</h2>
                    <p>Maintain and organize your item inventory</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/views/view-reports.jsp">
                <div class="card">
                    <div class="card-icon">📊</div>
                    <h2>View Reports</h2>
                    <p>Generate and review sales and usage reports</p>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/views/view-bills.jsp">
                <div class="card">
                    <div class="card-icon">🧾</div>
                    <h2>View Bills</h2>
                    <p>Check and manage customer billing records</p>
                </div>
            </a>
            
            <a href="${pageContext.request.contextPath}/views/help.jsp">
                <div class="card">
                    <div class="card-icon">❓</div>
                    <h2>Help</h2>
                    <p>Access system usage guide and FAQs</p>
                </div>
            </a>
        </div>

        <div style="text-align:center;">
            <a href="${pageContext.request.contextPath}/UserController" class="logout-btn">Logout</a>
        </div>
    </div>
</body>
</html>
