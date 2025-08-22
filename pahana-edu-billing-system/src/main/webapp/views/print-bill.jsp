<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pahana.model.Bill" %>
<%@ page import="com.pahana.model.BillItem" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Bill bill = (Bill) request.getAttribute("bill");
    if (bill == null) {
        response.sendRedirect("BillController");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill Preview - <%= bill.getBillId() %></title>
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
            --accent: 217.2 32.6% 17.5%;
            --accent-foreground: 210 40% 98%;
            --border: 217.2 32.6% 17.5%;
            --destructive: 0 62.8% 30.6%;
            --success: 142.1 76.2% 36.3%;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
            background: linear-gradient(135deg, hsl(var(--background)) 0%, hsl(217.2 32.6% 12%) 100%);
            color: hsl(var(--foreground));
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
            min-height: 100vh;
            padding: 2rem;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background: hsl(var(--card));
            border: 1px solid hsl(var(--border));
            border-radius: 1rem;
            padding: 3rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            position: relative;
            overflow: hidden;
        }

        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, hsl(var(--primary)), #60A5FA, hsl(var(--success)));
            background-size: 200% 100%;
            animation: gradientShift 3s ease-in-out infinite;
        }

        @keyframes gradientShift {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        .bill-header {
            text-align: center;
            padding-bottom: 2rem;
            margin-bottom: 3rem;
            border-bottom: 2px solid hsl(var(--border));
            position: relative;
        }

        .bill-header h1 {
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 1rem;
            letter-spacing: -0.025em;
        }

        .bill-id {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: hsl(var(--accent));
            color: hsl(var(--accent-foreground));
            padding: 0.75rem 1.5rem;
            border-radius: 2rem;
            font-weight: 600;
            font-size: 1rem;
            border: 1px solid hsl(var(--border));
        }

        .bill-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .info-section {
            background: hsl(var(--accent));
            padding: 2rem;
            border-radius: 1rem;
            border: 1px solid hsl(var(--border));
            transition: all 0.3s ease;
        }

        .info-section:hover {
            background: hsl(217.2 32.6% 20%);
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        .info-section h3 {
            font-size: 1.25rem;
            font-weight: 700;
            color: hsl(var(--foreground));
            margin-bottom: 1rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid hsl(var(--border));
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-section p {
            margin-bottom: 0.75rem;
            color: hsl(var(--muted-foreground));
            font-size: 0.95rem;
        }

        .info-section strong {
            color: hsl(var(--foreground));
            font-weight: 600;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
            background: hsl(var(--card));
            border-radius: 1rem;
            overflow: hidden;
            border: 1px solid hsl(var(--border));
        }

        .items-table th,
        .items-table td {
            padding: 1rem 1.5rem;
            text-align: left;
            border-bottom: 1px solid hsl(var(--border));
            font-size: 0.95rem;
        }

        .items-table th {
            background: hsl(var(--accent));
            font-weight: 700;
            color: hsl(var(--foreground));
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            position: sticky;
            top: 0;
        }

        .items-table tbody tr {
            transition: background-color 0.2s ease;
        }

        .items-table tbody tr:hover {
            background: hsl(var(--accent));
        }

        .items-table tbody tr:last-child td {
            border-bottom: none;
        }

        .total-row {
            background: linear-gradient(135deg, hsl(var(--primary)) 0%, #60A5FA 100%) !important;
            color: hsl(var(--primary-foreground)) !important;
        }

        .total-row td {
            font-weight: 700;
            font-size: 1.1rem;
            border-bottom: none !important;
        }

        .total-amount {
            font-size: 1.5rem !important;
            font-weight: 800;
        }

        .text-right {
            text-align: right;
        }

        .text-center {
            text-align: center;
        }

        .empty-state {
            text-align: center;
            color: hsl(var(--muted-foreground));
            font-style: italic;
            padding: 3rem 1rem;
        }

        .actions {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid hsl(var(--border));
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.875rem 2rem;
            border-radius: 0.75rem;
            font-weight: 600;
            font-size: 0.95rem;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            outline: none;
            position: relative;
            overflow: hidden;
            min-height: 48px;
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

        .btn-primary {
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
            color: hsl(var(--primary-foreground));
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3);
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
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .print-only {
            display: none;
        }

        /* Print styles */
        @media print {
            :root {
                --background: 0 0% 100%;
                --foreground: 222.2 84% 4.9%;
                --card: 0 0% 100%;
                --card-foreground: 222.2 84% 4.9%;
                --border: 220 13% 91%;
                --muted-foreground: 215.4 16.3% 46.9%;
                --accent: 210 40% 96%;
            }

            .no-print {
                display: none !important;
            }

            .print-only {
                display: block;
            }

            body {
                background: white;
                color: black;
                padding: 0;
            }

            .container {
                box-shadow: none;
                border: none;
                background: white;
                padding: 2rem;
                max-width: none;
            }

            .container::before {
                display: none;
            }

            .bill-header h1 {
                color: black;
                background: none;
                -webkit-text-fill-color: initial;
            }

            .info-section {
                background: #f8f9fa;
                border: 1px solid #dee2e6;
            }

            .items-table th {
                background: #f8f9fa;
                color: black;
            }

            .total-row {
                background: #e3f2fd !important;
                color: #1976d2 !important;
            }
        }

        /* Responsive design */
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }

            .container {
                padding: 2rem;
            }

            .bill-header h1 {
                font-size: 2rem;
            }

            .bill-info {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .actions {
                flex-direction: column;
                align-items: stretch;
            }

            .btn {
                width: 100%;
            }

            .items-table {
                font-size: 0.875rem;
            }

            .items-table th,
            .items-table td {
                padding: 0.75rem;
            }
        }

        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
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

        /* Icons */
        .icon {
            width: 20px;
            height: 20px;
            fill: none;
            stroke: currentColor;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Bill Header -->
        <div class="bill-header">
        		
            <h1>
            INVOICE</h1>
           
        </div>

        <!-- Bill Information -->
        <div class="bill-info">
            <div class="info-section">
                <h3>
                    <svg class="icon" viewBox="0 0 24 24">
                        <circle cx="12" cy="12" r="10"/>
                        <polyline points="12,6 12,12 16,14"/>
                    </svg>
                    Bill Details
                </h3>
                <p><strong>Date:</strong> <%= bill.getDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %></p>
                <p><strong>Payment Method:</strong> 
                    <span style="<%= bill.getPaymentMethod() != null ? "color: hsl(var(--success));" : "color: hsl(var(--muted-foreground));" %>">
                        <%= bill.getPaymentMethod() != null ? bill.getPaymentMethod() : "Not specified" %>
                    </span>
                </p>
            </div>
            
            <div class="info-section">
                <h3>
                    <svg class="icon" viewBox="0 0 24 24">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                    Customer Information
                </h3>
                <% if (bill.getCustomer() != null) { %>
                    
                    <p><strong>Customer Name:</strong> <%= bill.getCustomer().getName() %></p>
                    <p><strong>Account Number:</strong> 
                        <%= bill.getCustomer().getAccountNumber() != null ? bill.getCustomer().getAccountNumber() : "Not assigned" %>
                    </p>
                <% } else { %>
                    <p style="color: hsl(var(--muted-foreground)); font-style: italic;">No customer information available</p>
                <% } %>
            </div>
        </div>

        <!-- Items Table -->
        <table class="items-table">
            <thead>
                <tr>
                    <th>Item Code</th>
                    <th>Item Name</th>
                    <th class="text-center">Quantity</th>
                    <th class="text-right">Unit Price</th>
                    <th class="text-right">Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <% 
                if (bill.getItems() != null && !bill.getItems().isEmpty()) {
                    for (BillItem item : bill.getItems()) { 
                %>
                    <tr>
                        <td><%= item.getItem() != null ? item.getItem().getItemCode() : "N/A" %></td>
                        <td><%= item.getItem() != null ? item.getItem().getName() : "N/A" %></td>
                        <td class="text-center"><%= item.getQuantity() %></td>
                        <td class="text-right">$<%= String.format("%.2f", item.getUnitPrice()) %></td>
                        <td class="text-right">$<%= String.format("%.2f", item.calculateSubTotal()) %></td>
                    </tr>
                <% 
                    }
                } else {
                %>
                    <tr>
                        <td colspan="5" class="empty-state">
                            <svg class="icon" style="width: 48px; height: 48px; margin-bottom: 1rem; opacity: 0.5;" viewBox="0 0 24 24">
                                <circle cx="12" cy="12" r="10"/>
                                <path d="M16 16s-1.5-2-4-2-4 2-4 2"/>
                                <line x1="9" y1="9" x2="9.01" y2="9"/>
                                <line x1="15" y1="9" x2="15.01" y2="9"/>
                            </svg>
                            <div>No items found in this bill</div>
                        </td>
                    </tr>
                <% } %>
            </tbody>
            <tfoot>
                <tr class="total-row">
                    <td colspan="4" class="text-right"><strong>Total Amount:</strong></td>
                    <td class="text-right total-amount">
                        <strong>$<%= String.format("%.2f", bill.getTotalAmount()) %></strong>
                    </td>
                </tr>
            </tfoot>
        </table>

        <!-- Action Buttons -->
        <div class="actions no-print">
            <form action="GenerateBillPDF" method="post" style="display: inline;">
                <input type="hidden" name="billId" value="<%= bill.getBillId() %>"/>
                <button type="submit" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                        <polyline points="7,10 12,15 17,10"/>
                        <line x1="12" y1="15" x2="12" y2="3"/>
                    </svg>
                    Download PDF
                </button>
            </form>
            
            <button onclick="window.print()" class="btn btn-secondary">
                <svg class="icon" viewBox="0 0 24 24">
                    <polyline points="6,9 6,2 18,2 18,9"/>
                    <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/>
                    <rect x="6" y="14" width="12" height="8"/>
                </polyline>
                Print Bill
            </button>
            
            <a href="${pageContext.request.contextPath}/BillController?action=list" class="btn btn-secondary">
                <svg class="icon" viewBox="0 0 24 24">
                    <path d="M19 12H6m6-7-7 7 7 7"/>
                </svg>
                Back to Bills
            </a>
        </div>

        <!-- Print Footer -->
        <div class="print-only">
            <hr style="margin-top: 50px; border: none; border-top: 2px solid #ddd;">
            <p style="text-align: center; font-size: 14px; color: #666; margin-top: 20px;">
                <strong>Thank you for your business!</strong><br>
                Generated on <%= java.time.LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %><br>
                <em>This is a computer-generated document.</em>
            </p>
        </div>
    </div>

    <script>
        // Add loading state for PDF generation
        document.querySelector('form[action="GenerateBillPDF"]').addEventListener('submit', function(e) {
            const button = this.querySelector('button');
            const originalContent = button.innerHTML;
            
            button.innerHTML = `
                <div style="width: 20px; height: 20px; border: 2px solid rgba(255,255,255,0.3); border-radius: 50%; border-top-color: white; animation: spin 1s linear infinite;"></div>
                Generating...
            `;
            button.disabled = true;
            
            // Re-enable after 5 seconds (fallback)
            setTimeout(() => {
                button.innerHTML = originalContent;
                button.disabled = false;
            }, 5000);
        });

        // Add smooth animations
        document.querySelectorAll('.info-section').forEach(section => {
            section.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-4px) scale(1.02)';
            });
            
            section.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });

        // Add CSS for spinner animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes spin {
                to { transform: rotate(360deg); }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>