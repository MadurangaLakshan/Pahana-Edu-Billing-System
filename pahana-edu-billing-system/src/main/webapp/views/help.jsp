<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Help - Pahana Edu Billing System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/lucide/0.263.1/lucide.min.css" rel="stylesheet">
    <style>
        :root {
            --background: 222.2 84% 4.9%;
            --foreground: 210 40% 98%;
            --card: 222.2 84% 4.9%;
            --card-foreground: 210 40% 98%;
            --primary: 217.2 91.2% 59.8%;
            --primary-foreground: 222.2 84% 4.9%;
            --secondary: 217.2 32.6% 17.5%;
            --secondary-foreground: 210 40% 98%;
            --muted: 217.2 32.6% 17.5%;
            --muted-foreground: 215 20.2% 65.1%;
            --border: 217.2 32.6% 17.5%;
            --success: 142.1 76.2% 36.3%;
            --warning: 45.4 93.4% 47.5%;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: hsl(var(--background));
            color: hsl(var(--foreground));
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .header {
            text-align: center;
            margin-bottom: 3rem;
            padding-bottom: 2rem;
            border-bottom: 2px solid hsl(var(--border));
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }

        .header p {
            color: hsl(var(--muted-foreground));
            font-size: 1.1rem;
        }

        .help-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .help-card {
            background: hsl(var(--card));
            border: 1px solid hsl(var(--border));
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .help-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.4);
        }

        .help-card-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid hsl(var(--border));
        }

        .help-icon {
            width: 2rem;
            height: 2rem;
            margin-right: 0.75rem;
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .help-card h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: hsl(var(--primary));
        }

        .help-steps {
            list-style: none;
            counter-reset: step-counter;
        }

        .help-steps li {
            counter-increment: step-counter;
            margin-bottom: 0.75rem;
            padding-left: 2rem;
            position: relative;
            color: hsl(var(--muted-foreground));
        }

        .help-steps li::before {
            content: counter(step-counter);
            position: absolute;
            left: 0;
            top: 0;
            background: hsl(var(--primary));
            color: hsl(var(--primary-foreground));
            width: 1.5rem;
            height: 1.5rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .quick-tips {
            background: hsl(var(--secondary));
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .quick-tips h2 {
            color: hsl(var(--warning));
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .tips-list {
            list-style: none;
        }

        .tips-list li {
            margin-bottom: 0.5rem;
            padding-left: 1.5rem;
            position: relative;
            color: hsl(var(--muted-foreground));
        }

        .tips-list li::before {
            content: "💡";
            position: absolute;
            left: 0;
            top: 0;
        }

        .navigation-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
            color: hsl(var(--primary-foreground));
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.4);
        }

        .btn-secondary {
            background: hsl(var(--secondary));
            color: hsl(var(--secondary-foreground));
            border: 1px solid hsl(var(--border));
        }

        .btn-secondary:hover {
            background: hsl(var(--muted));
            transform: translateY(-1px);
        }

        .system-info {
            background: linear-gradient(135deg, rgba(59, 130, 246, 0.1), rgba(96, 165, 250, 0.1));
            border: 1px solid rgba(59, 130, 246, 0.3);
            border-radius: 0.75rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .system-info h2 {
            color: hsl(var(--primary));
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .container { padding: 1rem; }
            .help-grid { grid-template-columns: 1fr; }
            .header h1 { font-size: 2rem; }
            .navigation-buttons { flex-direction: column; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Help & User Guide</h1>
            <p>Complete guide to using the Pahana Edu Billing System</p>
        </div>

        <div class="system-info">
            <h2>📚 About Pahana Edu Billing System</h2>
            <p>Welcome to Pahana Edu, Colombo City's leading bookshop billing management system. This comprehensive platform helps you manage customer accounts, process billing, and maintain inventory efficiently. Our system handles hundreds of customers monthly with secure, user-friendly features designed for bookshop operations.</p>
        </div>

        <div class="quick-tips">
            <h2>⚡ Quick Tips for New Users</h2>
            <ul class="tips-list">
                <li>Always log in with your assigned username and password before accessing system features</li>
                <li>Each customer must have a unique account number - the system will validate this automatically</li>
                <li>Save your work frequently, especially when adding multiple customer records</li>
                <li>Use the search function to quickly find existing customer accounts</li>
                <li>Bills are automatically calculated based on items and quantities - double-check before printing</li>
                <li>Keep customer information up-to-date for accurate billing and communication</li>
            </ul>
        </div>

        <div class="help-grid">
            <div class="help-card">
                <div class="help-card-header">
                    <div class="help-icon">🔐</div>
                    <h3>User Authentication</h3>
                </div>
                <ol class="help-steps">
                    <li>Enter your assigned username in the login field</li>
                    <li>Type your secure password</li>
                    <li>Click "Sign In" to access the system</li>
                    <li>If credentials are incorrect, you'll see an error message</li>
                    <li>Contact your administrator if you forget your password</li>
                </ol>
            </div>

            <div class="help-card">
                <div class="help-card-header">
                    <div class="help-icon">👥</div>
                    <h3>Add New Customer</h3>
                </div>
                <ol class="help-steps">
                    <li>Navigate to "Add Customer" from the main menu</li>
                    <li>Enter a unique account number</li>
                    <li>Fill in customer name, address, and telephone number</li>
                    <li>Add any additional required information</li>
                    <li>Click "Save Customer" to register the new account</li>
                    <li>Verify the information before confirming</li>
                </ol>
            </div>

            <div class="help-card">
                <div class="help-card-header">
                    <div class="help-icon">✏️</div>
                    <h3>Edit Customer Information</h3>
                </div>
                <ol class="help-steps">
                    <li>Go to "Manage Customers" section</li>
                    <li>Search for the customer using account number or name</li>
                    <li>Click "Edit" next to the customer record</li>
                    <li>Update the necessary information fields</li>
                    <li>Save changes and confirm modifications</li>
                    <li>The system will update the customer database</li>
                </ol>
            </div>

            <div class="help-card">
                <div class="help-card-header">
                    <div class="help-icon">📦</div>
                    <h3>Manage Item Information</h3>
                </div>
                <ol class="help-steps">
                    <li>Access "Inventory Management" from the main menu</li>
                    <li>To add: Click "Add New Item" and enter details</li>
                    <li>To update: Select item and modify information</li>
                    <li>To delete: Select item and confirm deletion</li>
                    <li>Set prices, stock quantities, and descriptions</li>
                    <li>Save all changes to update inventory</li>
                </ol>
            </div>

            <div class="help-card">
                <div class="help-card-header">
                    <div class="help-icon">🔍</div>
                    <h3>Display Account Details</h3>
                </div>
                <ol class="help-steps">
                    <li>Select "View Customer Accounts" option</li>
                    <li>Use search filters (account number, name, etc.)</li>
                    <li>Click on a customer to view full details</li>
                    <li>Review account history and transaction records</li>
                    <li>Export or print account information if needed</li>
                    <li>Use filters to sort by date, amount, or status</li>
                </ol>
            </div>

            <div class="help-card">
                <div class="help-card-header">
                    <div class="help-icon">🧾</div>
                    <h3>Calculate and Print Bills</h3>
                </div>
                <ol class="help-steps">
                    <li>Go to "Billing" section</li>
                    <li>Select customer account</li>
                    <li>Add items purchased with quantities</li>
                    <li>System automatically calculates total amount</li>
                    <li>Review bill details for accuracy</li>
                    <li>Print or save the bill for customer</li>
                    <li>Mark transaction as completed</li>
                </ol>
            </div>
        </div>

        <div class="help-card" style="margin-bottom: 2rem;">
            <div class="help-card-header">
                <div class="help-icon">⚠️</div>
                <h3>Common Issues & Solutions</h3>
            </div>
            <div style="color: hsl(var(--muted-foreground));">
                <p><strong>Login Problems:</strong> Ensure caps lock is off and check for typos. Contact admin if issues persist.</p>
                <br>
                <p><strong>Duplicate Account Numbers:</strong> Each customer must have a unique account number. System will alert you to duplicates.</p>
                <br>
                <p><strong>Billing Errors:</strong> Double-check item quantities and prices before finalizing bills.</p>
                <br>
                <p><strong>System Performance:</strong> Refresh the page if system seems slow or unresponsive.</p>
            </div>
        </div>

        <div class="navigation-buttons">
            <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn btn-primary">
                🏠 Back to Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/customers.jsp" class="btn btn-secondary">
                👥 Manage Customers
            </a>
            <a href="${pageContext.request.contextPath}/billing.jsp" class="btn btn-secondary">
                🧾 Create Bill
            </a>
            <a href="${pageContext.request.contextPath}/inventory.jsp" class="btn btn-secondary">
                📦 Manage Items
            </a>
        </div>
    </div>
</body>
</html>