<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="com.pahana.dao.CustomerDAO" %>
<%@ page import="com.pahana.dao.ItemDAO" %>
<%@ page import="com.pahana.model.Customer" %>
<%@ page import="com.pahana.model.Item" %>
<%@ page import="java.util.List" %>

<%
    // Fetch data from database
    CustomerDAO customerDAO = new CustomerDAO();
    ItemDAO itemDAO = new ItemDAO();
    List<Customer> customers = customerDAO.getAllCustomers();
    List<Item> items = itemDAO.getAllItems();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Billing Form - Pahana Edu</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>
    	var contextPath = '<%= request.getContextPath() %>';
	</script>
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
            --success: 142.1 70.6% 45.3%;
            --destructive: 0 84.2% 60.2%;
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: hsl(var(--background));
            color: hsl(var(--foreground));
            margin: 0;
            padding: 2rem;
            min-height: 100vh;
            line-height: 1.6;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
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
            margin-bottom: 0.5rem;
        }

        .header p {
            color: hsl(var(--muted-foreground));
        }

        .section {
            background: hsl(var(--card));
            border: 1px solid hsl(var(--border));
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .section h2 {
            color: hsl(var(--primary));
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .search-container {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            align-items: center;
        }

        .form-input, .form-select {
            background: hsl(var(--muted));
            border: 1px solid hsl(var(--border));
            color: hsl(var(--foreground));
            padding: 0.75rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.9rem;
            transition: all 0.2s;
            width: 100%;
        }

        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: hsl(var(--primary));
            box-shadow: 0 0 0 2px hsla(var(--primary), 0.2);
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.9rem;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px hsla(var(--primary), 0.4);
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.8rem;
        }

        .btn-success {
            background: linear-gradient(135deg, hsl(var(--success)), #22c55e);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px hsla(var(--success), 0.4);
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .table th,
        .table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid hsl(var(--border));
        }

        .table th {
            background: hsl(var(--muted));
            color: hsl(var(--foreground));
            font-weight: 600;
            position: sticky;
            top: 0;
        }

        .table tr:hover {
            background: hsl(var(--muted) / 0.5);
        }

        .customer-table, .items-table {
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid hsl(var(--border));
            border-radius: 0.5rem;
        }

        .selected-customer {
            background: hsla(var(--primary), 0.2) !important;
            border: 2px solid hsl(var(--primary));
        }

        .total-section {
            background: linear-gradient(135deg, hsl(var(--primary) / 0.1), hsl(var(--success) / 0.1));
            padding: 2rem;
            border-radius: 1rem;
            text-align: center;
            margin-top: 2rem;
        }

        .total-amount {
            font-size: 2rem;
            font-weight: 700;
            color: hsl(var(--success));
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }

        @media (max-width: 768px) {
            .grid {
                grid-template-columns: 1fr;
            }
            
            .search-container {
                flex-direction: column;
            }
        }

        .customer-info {
            background: hsla(var(--primary), 0.1);
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .qty-input {
            width: 80px;
            text-align: center;
        }
    </style>
    <script>
    let billItems = [];
    let selectedCustomer = null;
    
    // Remove this line completely:
    // const contextPath = "${pageContext.request.contextPath}";
    
    let allCustomers = [
        <% for (int i = 0; i < customers.size(); i++) {
            Customer customer = customers.get(i);
        %>
        {
            id: '<%= customer.getCustomerId() %>',
            accountNumber: '<%= customer.getAccountNumber() %>',
            name: '<%= customer.getName() %>',
            email: '<%= customer.getEmail() %>',
            phone: '<%= customer.getTelephone() %>',
            address: '<%= customer.getAddress() %>'
        }<%= i < customers.size() - 1 ? "," : "" %>
        <% } %>
    ];

    // Create item lookup map for getting item IDs from codes
    let itemMap = new Map();
    <% for (Item item : items) { %>
    itemMap.set('<%= item.getItemCode() %>', {
        itemId: <%= item.getItemId() %>,
        name: '<%= item.getName() %>',
        price: <%= item.getPrice() %>
    });
    <% } %>

    function searchCustomers() {
        const searchTerm = document.getElementById('customerSearch').value.toLowerCase();
        const filteredCustomers = allCustomers.filter(customer => 
            customer.name.toLowerCase().includes(searchTerm) ||
            customer.accountNumber.toLowerCase().includes(searchTerm) ||
            customer.email.toLowerCase().includes(searchTerm) ||
            customer.phone.toLowerCase().includes(searchTerm)
        );
        renderCustomerTable(filteredCustomers);
    }

    function renderCustomerTable(customers = allCustomers) {
        const tbody = document.getElementById('customerTableBody');
        tbody.innerHTML = '';
        
        customers.forEach(customer => {
            const isSelected = selectedCustomer && selectedCustomer.id === customer.id;
            tbody.innerHTML += `
                <tr onclick="selectCustomer('${customer.id}')" 
                    class="${isSelected ? 'selected-customer' : ''}" 
                    style="cursor: pointer;">
                    <td>${customer.accountNumber}</td>
                    <td>${customer.name}</td>
                    <td>${customer.email}</td>
                    <td>${customer.phone}</td>
                </tr>
            `;
        });
    }

    function selectCustomer(customerId) {
        selectedCustomer = allCustomers.find(c => c.id === customerId);
        renderCustomerTable();
        updateSelectedCustomerInfo();
    }

    function updateSelectedCustomerInfo() {
        const infoDiv = document.getElementById('selectedCustomerInfo');
        if (selectedCustomer) {
            infoDiv.innerHTML = `
                <strong>Selected Customer:</strong> ${selectedCustomer.name} (${selectedCustomer.accountNumber})
                <br><strong>Email:</strong> ${selectedCustomer.email}
                <br><strong>Phone:</strong> ${selectedCustomer.phone}
                <br><strong>Address:</strong> ${selectedCustomer.address}
            `;
            infoDiv.style.display = 'block';
        } else {
            infoDiv.style.display = 'none';
        }
    }

    function addToBill(itemCode, itemName, itemPrice) {
        let existing = billItems.find(i => i.id === itemCode);
        if (existing) {
            existing.qty += 1;
        } else {
            billItems.push({ id: itemCode, name: itemName, price: itemPrice, qty: 1 });
        }
        renderBillTable();
    }

    function updateQty(itemCode, newQty) {
        let item = billItems.find(i => i.id === itemCode);
        if (item) {
            item.qty = parseInt(newQty) || 0;
            if (item.qty <= 0) {
                removeItem(itemCode);
                return;
            }
        }
        renderBillTable();
    }

    function removeItem(itemCode) {
        billItems = billItems.filter(i => i.id !== itemCode);
        renderBillTable();
    }

    function renderBillTable() {
        let tbody = document.getElementById("billTableBody");
        tbody.innerHTML = "";
        let total = 0;

        billItems.forEach(item => {
            let subTotal = item.qty * item.price;
            total += subTotal;
            tbody.innerHTML += `
                <tr>
                    <td>${item.id}</td>
                    <td>${item.name}</td>
                    <td>
                        <input type="number" min="1" value="${item.qty}" 
                               onchange="updateQty('${item.id}', this.value)" 
                               class="form-input qty-input">
                    </td>
                    <td>LKR ${item.price.toFixed(2)}</td>
                    <td>LKR ${subTotal.toFixed(2)}</td>
                    <td>
                        <button type="button" class="btn btn-sm" 
                                style="background: hsl(var(--destructive)); color: white;"
                                onclick="removeItem('${item.id}')">Remove</button>
                    </td>
                </tr>
            `;
        });

        document.getElementById("billTotal").innerText = `LKR ${total.toFixed(2)}`;
    }

    function processBill() {
        if (!selectedCustomer) {
            alert('Please select a customer first!');
            return;
        }
        if (billItems.length === 0) {
            alert('Please add items to the bill!');
            return;
        }

      
        const paymentSelect = document.getElementById('paymentMethodSelect');
        const paymentMethod = paymentSelect.value;


        // Create form for submission
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = contextPath + '/BillController';  // Use the global contextPath variable
        form.style.display = 'none';

        // Add action
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'create';
        form.appendChild(actionInput);

        // Add customer ID
        const customerInput = document.createElement('input');
        customerInput.type = 'hidden';
        customerInput.name = 'customerId';
        customerInput.value = selectedCustomer.id;
        form.appendChild(customerInput);

        // Add payment method
        const paymentInput = document.createElement('input');
        paymentInput.type = 'hidden';
        paymentInput.name = 'paymentMethod';
        paymentInput.value = paymentMethod;
        form.appendChild(paymentInput);

        // Add bill items - send itemCode to match what controller expects
        billItems.forEach((item, index) => {
            // Add itemCode
            const itemCodeInput = document.createElement('input');
            itemCodeInput.type = 'hidden';
            itemCodeInput.name = 'itemCode';
            itemCodeInput.value = item.id; // This contains the itemCode
            form.appendChild(itemCodeInput);

            // Add quantity
            const qtyInput = document.createElement('input');
            qtyInput.type = 'hidden';
            qtyInput.name = 'quantity';
            qtyInput.value = item.qty;
            form.appendChild(qtyInput);

            // Add unit price
            const priceInput = document.createElement('input');
            priceInput.type = 'hidden';
            priceInput.name = 'unitPrice';
            priceInput.value = item.price;
            form.appendChild(priceInput);
        });

        // Submit form
        document.body.appendChild(form);
        
        // Show processing message
        const processingMsg = document.createElement('div');
        processingMsg.style.position = 'fixed';
        processingMsg.style.top = '50%';
        processingMsg.style.left = '50%';
        processingMsg.style.transform = 'translate(-50%, -50%)';
        processingMsg.style.background = 'hsl(var(--card))';
        processingMsg.style.padding = '2rem';
        processingMsg.style.borderRadius = '1rem';
        processingMsg.style.border = '1px solid hsl(var(--border))';
        processingMsg.style.color = 'hsl(var(--foreground))';
        processingMsg.style.zIndex = '9999';
        processingMsg.innerHTML = 'Processing bill...';
        document.body.appendChild(processingMsg);
        
        form.submit();
    }

    // Initialize on page load
    window.onload = function() {
        renderCustomerTable();
        console.log('Context Path:', contextPath); // Debug line
    }
</script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧾 Billing System</h1>
            <p>Create and manage customer bills efficiently</p>
        </div>

        <div class="grid">
            <!-- Customer Selection Section -->
            <div class="section">
                <h2>👥 Select Customer</h2>
                
                <div class="search-container">
                    <input type="text" id="customerSearch" class="form-input" 
                           placeholder="Search customers by name, account number, email, or phone..." 
                           onkeyup="searchCustomers()">
                    <button type="button" class="btn btn-primary" onclick="searchCustomers()">Search</button>
                </div>

                <div id="selectedCustomerInfo" class="customer-info" style="display: none;"></div>

                <div class="customer-table">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Account Number</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                            </tr>
                        </thead>
                        <tbody id="customerTableBody">
                            <!-- Dynamically populated -->
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Items Section -->
            <div class="section">
                <h2>📦 Available Items</h2>
                <div class="items-table">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Item Code</th>
                                <th>Name</th>
                                <th>Category</th>
                                <th>Stock</th>
                                <th>Price (LKR)</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Item item : items) { %>
                            <tr>
                                <td><%= item.getItemCode() %></td>
                                <td><%= item.getName() %></td>
                                <td><%= item.getCategory() %></td>
                                <td><%= item.getStockQuantity() %></td>
                                <td><%= String.format("%.2f", item.getPrice()) %></td>
                                <td>
                                    <% if (item.getStockQuantity() > 0) { %>
                                    <button type="button" class="btn btn-sm btn-primary" 
                                            onclick="addToBill('<%= item.getItemCode() %>', '<%= item.getName() %>', <%= item.getPrice() %>)">
                                        Add
                                    </button>
                                    <% } else { %>
                                    <span style="color: hsl(var(--destructive));">Out of Stock</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Bill Details Section -->
        <div class="section">
            <h2>🧾 Bill Details</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>Item Code</th>
                        <th>Name</th>
                        <th>Quantity</th>
                        <th>Price (LKR)</th>
                        <th>Subtotal (LKR)</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="billTableBody">
                    <!-- Dynamically added rows -->
                </tbody>
            </table>

            <div class="total-section">
                <h3>Total Amount</h3>
                <div class="total-amount" id="billTotal">LKR 0.00</div>
                <div style="margin-top: 1rem; text-align: center;">
    <label for="paymentMethodSelect" style="margin-right: 0.5rem; font-weight: 600;">Payment Method:</label>
    <select id="paymentMethodSelect" class="form-select" style="width: 200px; display: inline-block;">
        <option value="Cash">Cash</option>
        <option value="Card">Card</option>
        <option value="Bank Transfer">Bank Transfer</option>
    </select>
</div>
                
                <button type="button" class="btn btn-success" onclick="processBill()" style="margin-top: 1rem;">
                    Process Bill
                </button>
            </div>
        </div>
    </div>
</body>
</html>