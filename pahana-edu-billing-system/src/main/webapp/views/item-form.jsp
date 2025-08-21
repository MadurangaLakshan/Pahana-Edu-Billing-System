<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${item != null ? 'Update Item' : 'Add Item'}</title>
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
            --warning: 43 96% 56%;
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }

        .form-container {
            width: 100%;
            max-width: 600px;
            background: hsl(var(--card));
            border: 1px solid hsl(var(--border));
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.15);
            position: relative;
            overflow: hidden;
        }

        .form-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, hsl(var(--primary)), #60A5FA, hsl(var(--primary)));
            background-size: 200% 100%;
            animation: gradientShift 3s ease-in-out infinite;
        }

        @keyframes gradientShift {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        .header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .header h1 {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(135deg, hsl(var(--primary)), #60A5FA);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }

        .header p {
            color: hsl(var(--muted-foreground));
            font-size: 0.95rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: hsl(var(--foreground));
            font-size: 0.875rem;
            letter-spacing: 0.025em;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 0.75rem 1rem;
            background: hsl(var(--input));
            border: 1px solid hsl(var(--border));
            border-radius: 0.5rem;
            color: hsl(var(--foreground));
            font-size: 0.875rem;
            transition: all 0.2s ease-in-out;
            outline: none;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            border-color: hsl(var(--primary));
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            background: hsl(var(--background));
        }

        .form-input:hover, .form-select:hover, .form-textarea:hover {
            border-color: hsl(var(--muted-foreground));
        }

        .form-input::placeholder, .form-textarea::placeholder {
            color: hsl(var(--muted-foreground));
        }

        .form-textarea {
            min-height: 100px;
            resize: vertical;
            font-family: inherit;
        }

        .form-select {
            cursor: pointer;
        }

        .form-select option {
            background: hsl(var(--background));
            color: hsl(var(--foreground));
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
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
            flex: 1;
            min-height: 44px;
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

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: hsl(var(--muted-foreground));
            text-decoration: none;
            font-size: 0.875rem;
            margin-top: 1.5rem;
            transition: color 0.2s;
        }

        .back-link:hover {
            color: hsl(var(--primary));
        }

        .input-with-icon {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: hsl(var(--muted-foreground));
            pointer-events: none;
        }

        .input-with-icon .form-input, .input-with-icon .form-select {
            padding-left: 2.5rem;
        }

        .required {
            color: hsl(var(--destructive));
            margin-left: 2px;
        }

        .form-hint {
            font-size: 0.75rem;
            color: hsl(var(--muted-foreground));
            margin-top: 0.25rem;
        }

        .stock-indicator {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
            font-weight: 500;
            margin-top: 0.25rem;
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

        @media (max-width: 768px) {
            .form-container {
                padding: 1.5rem;
                max-width: 500px;
            }
            
            .header h1 {
                font-size: 1.75rem;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .form-actions {
                flex-direction: column;
            }
        }

        .loading-spinner {
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
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
    </style>
</head>
<body>
    <div class="form-container">
        <div class="header">
            <h1>
                <c:choose>
                    <c:when test="${item != null}">Update Item</c:when>
                    <c:otherwise>Add New Item</c:otherwise>
                </c:choose>
            </h1>
            <p>
                <c:choose>
                    <c:when test="${item != null}">Modify item information and inventory details</c:when>
                    <c:otherwise>Enter item details to add to your inventory</c:otherwise>
                </c:choose>
            </p>
        </div>

        <form action="${pageContext.request.contextPath}/ItemController" method="post" id="itemForm">
            <input type="hidden" name="action" value="${item != null ? 'update' : 'add'}"/>
			
			<!-- Add hidden field for itemId when updating -->
            <c:if test="${item != null}">
                <input type="hidden" name="itemId" value="${item.itemId}" />
            </c:if>

            <div class="form-grid">
                <div class="form-group">
                    <label for="itemCode" class="form-label">
                        Item Code <span class="required">*</span>
                    </label>
                    <div class="input-with-icon">
                        <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="2" y="3" width="20" height="14" rx="2" ry="2"/>
                            <line x1="8" y1="21" x2="16" y2="21"/>
                            <line x1="12" y1="17" x2="12" y2="21"/>
                        </svg>
                        <input 
                            type="text" 
                            id="itemCode" 
                            name="itemCode" 
                            class="form-input" 
                            value="${item != null ? item.itemCode : ''}" 
                            placeholder="Generated automatically"
                            readonly
                            required
                            style="font-family: 'Courier New', monospace;"
                        />
                    </div>
                    <div class="form-hint">Generated automatically on save (C0001, C0002, etc.)</div>
                </div>

                <div class="form-group">
                    <label for="category" class="form-label">
                        Category <span class="required">*</span>
                    </label>
                    <div class="input-with-icon">
                        <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="3" width="7" height="7"/>
                            <rect x="14" y="3" width="7" height="7"/>
                            <rect x="14" y="14" width="7" height="7"/>
                            <rect x="3" y="14" width="7" height="7"/>
                        </svg>
                        <select 
                            id="category" 
                            name="category" 
                            class="form-select"
                            required
                        >
                            <option value="">Select category</option>
                            <option value="Books" ${item != null && item.category == 'Electronics' ? 'selected' : ''}>Books</option>
                            <option value="Stationery" ${item != null && item.category == 'Clothing' ? 'selected' : ''}>Stationery</option>
                            <option value="Office Supplies" ${item != null && item.category == 'Books' ? 'selected' : ''}>Office Supplies	</option>
  
                            <option value="Other" ${item != null && item.category == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                    <div class="form-hint">Product classification</div>
                </div>
            </div>

            <div class="form-group full-width">
                <label for="name" class="form-label">
                    Item Name <span class="required">*</span>
                </label>
                <div class="input-with-icon">
                    <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 7h-9"/>
                        <path d="M14 17H5"/>
                        <circle cx="17" cy="17" r="3"/>
                        <circle cx="7" cy="7" r="3"/>
                    </svg>
                    <input 
                        type="text" 
                        id="name" 
                        name="name" 
                        class="form-input" 
                        value="${item != null ? item.name : ''}" 
                        placeholder="Enter descriptive item name"
                        required
                    />
                </div>
                <div class="form-hint">Clear, descriptive name for the product</div>
            </div>

            <div class="form-group full-width">
                <label for="description" class="form-label">
                    Description
                </label>
                <textarea 
                    id="description" 
                    name="description" 
                    class="form-textarea"
                    placeholder="Provide detailed description of the item, including features, specifications, or other relevant information..."
                >${item != null ? item.description : ''}</textarea>
                <div class="form-hint">Optional detailed description for better inventory management</div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label for="price" class="form-label">
                        Unit Price <span class="required">*</span>
                    </label>
                    <div class="input-with-icon">
                        <span class="input-icon">LKR</span>

                        <input 
                            type="number" 
                            id="price" 
                            name="price" 
                            class="form-input" 
                            value="${item != null ? item.price : ''}" 
                            placeholder="0.00"
                            step="0.01"
                            min="0"
                            required
                        />
                    </div>
                    <div class="form-hint">Price per unit in your currency</div>
                    
                </div>

                <div class="form-group">
                    <label for="stockQuantity" class="form-label">
                        Stock Quantity <span class="required">*</span>
                    </label>
                    <div class="input-with-icon">
                        <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M16 11V7a4 4 0 0 0-8 0v4"/>
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                            <circle cx="12" cy="16" r="1"/>
                        </svg>
                        <input 
                            type="number" 
                            id="stockQuantity" 
                            name="stockQuantity" 
                            class="form-input" 
                            value="${item != null ? item.stockQuantity : ''}" 
                            placeholder="0"
                            min="0"
                            required
                        />
                    </div>
                    <div class="form-hint">Current quantity in stock</div>
                    <div id="stockIndicator" class="stock-indicator" style="display: none;"></div>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                        <polyline points="17,21 17,13 7,13 7,21"/>
                        <polyline points="7,3 7,8 15,8"/>
                    </svg>
                    <c:choose>
                        <c:when test="${item != null}">Update Item</c:when>
                        <c:otherwise>Create Item</c:otherwise>
                    </c:choose>
                </button>
                
                <a href="${pageContext.request.contextPath}/ItemController?action=list" class="btn btn-secondary">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M19 12H6m6-7-7 7 7 7"/>
                    </svg>
                    Cancel
                </a>
            </div>
        </form>

        <a href="${pageContext.request.contextPath}/ItemController?action=list" class="back-link">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 12H6m6-7-7 7 7 7"/>
            </svg>
            Back to Item List
        </a>
    </div>

    <script>
        // Form validation and loading states
        document.getElementById('itemForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const originalContent = submitBtn.innerHTML;
            
            // Show loading state
            submitBtn.innerHTML = '<div class="loading-spinner"></div> Processing...';
            submitBtn.disabled = true;
            
            // Re-enable after 3 seconds if form doesn't submit (fallback)
            setTimeout(() => {
                submitBtn.innerHTML = originalContent;
                submitBtn.disabled = false;
            }, 3000);
        });

        // Item code is generated server-side, no frontend generation needed

        // Price formatting
        document.getElementById('price').addEventListener('blur', function(e) {
            const value = parseFloat(e.target.value);
            if (!isNaN(value)) {
                e.target.value = value.toFixed(2);
            }
        });

        // Stock quantity indicator
        document.getElementById('stockQuantity').addEventListener('input', function(e) {
            const quantity = parseInt(e.target.value);
            const indicator = document.getElementById('stockIndicator');
            
            if (!isNaN(quantity) && quantity >= 0) {
                indicator.style.display = 'inline-block';
                
                if (quantity > 50) {
                    indicator.className = 'stock-indicator stock-high';
                    indicator.textContent = 'Good Stock Level';
                } else if (quantity > 10) {
                    indicator.className = 'stock-indicator stock-medium';
                    indicator.textContent = 'Low Stock Warning';
                } else {
                    indicator.className = 'stock-indicator stock-low';
                    indicator.textContent = 'Critical Stock Level';
                }
            } else {
                indicator.style.display = 'none';
            }
        });

        // Form field animations
        document.querySelectorAll('.form-input, .form-select, .form-textarea').forEach(input => {
            input.addEventListener('focus', function() {
                const icon = this.parentNode.querySelector('.input-icon');
                if (icon) {
                    icon.style.color = 'hsl(var(--primary))';
                }
            });
            
            input.addEventListener('blur', function() {
                const icon = this.parentNode.querySelector('.input-icon');
                if (icon) {
                    icon.style.color = 'hsl(var(--muted-foreground))';
                }
            });
        });

        // Remove the item code formatting since field is now readonly
        // Item code is auto-generated and readonly

        // Initialize stock indicator if editing
        window.addEventListener('DOMContentLoaded', function() {
            const stockInput = document.getElementById('stockQuantity');
            if (stockInput.value) {
                stockInput.dispatchEvent(new Event('input'));
            }
        });
    </script>
</body>
</html>