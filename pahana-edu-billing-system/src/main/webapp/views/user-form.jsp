<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${user != null ? 'Update User' : 'Add User'}</title>
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
            max-width: 500px;
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

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: hsl(var(--foreground));
            font-size: 0.875rem;
            letter-spacing: 0.025em;
        }

        .form-input, .form-select {
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

        .form-input:focus, .form-select:focus {
            border-color: hsl(var(--primary));
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            background: hsl(var(--background));
        }

        .form-input:hover, .form-select:hover {
            border-color: hsl(var(--muted-foreground));
        }

        .form-input::placeholder {
            color: hsl(var(--muted-foreground));
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

        .role-badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
            font-weight: 500;
            margin-top: 0.25rem;
        }

        .role-admin {
            background: rgba(239, 68, 68, 0.1);
            color: #EF4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .role-staff {
            background: rgba(34, 197, 94, 0.1);
            color: hsl(var(--success));
            border: 1px solid rgba(34, 197, 94, 0.2);
        }

        @media (max-width: 768px) {
            .form-container {
                padding: 1.5rem;
                max-width: 450px;
            }
            
            .header h1 {
                font-size: 1.75rem;
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

        .password-strength {
            margin-top: 0.5rem;
            font-size: 0.75rem;
        }

        .strength-weak { color: #EF4444; }
        .strength-medium { color: hsl(var(--warning)); }
        .strength-strong { color: hsl(var(--success)); }

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
                    <c:when test="${user != null}">Update User</c:when>
                    <c:otherwise>Add New User</c:otherwise>
                </c:choose>
            </h1>
            <p>
                <c:choose>
                    <c:when test="${user != null}">Modify user information and access permissions</c:when>
                    <c:otherwise>Create a new user account for the system</c:otherwise>
                </c:choose>
            </p>
        </div>

        <form action="${pageContext.request.contextPath}/UserController" method="post" id="userForm">
            <input type="hidden" name="action" value="save"/>
            
            <c:if test="${user != null}">
                <input type="hidden" name="userId" value="${user.userId}"/>
            </c:if>

            <div class="form-group">
                <label for="username" class="form-label">
                    Username <span class="required">*</span>
                </label>
                <div class="input-with-icon">
                    <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                    <input 
                        type="text" 
                        id="username" 
                        name="username" 
                        class="form-input" 
                        value="${user != null ? user.username : ''}" 
                        placeholder="Enter unique username"
                        required
                        minlength="3"
                        maxlength="50"
                    />
                </div>
                <div class="form-hint">Unique identifier for system access (3-50 characters)</div>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">
                    Password 
                    <c:if test="${user == null}"><span class="required">*</span></c:if>
                </label>
                <div class="input-with-icon">
                    <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        class="form-input"
                        placeholder="${user != null ? 'Leave blank to keep current password' : 'Enter secure password'}"
                        <c:if test="${user == null}">required</c:if>
                        minlength="6"
                    />
                </div>
                <div class="form-hint">
                    <c:choose>
                        <c:when test="${user != null}">Leave blank to keep current password</c:when>
                        <c:otherwise>Minimum 6 characters required</c:otherwise>
                    </c:choose>
                </div>
                <div id="passwordStrength" class="password-strength" style="display: none;"></div>
            </div>

            <div class="form-group">
                <label for="role" class="form-label">
                    Role <span class="required">*</span>
                </label>
                <div class="input-with-icon">
                    <svg class="input-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 12l2 2 4-4"/>
                        <path d="M21 12c-1 0-3-1-3-3s2-3 3-3 3 1 3 3-2 3-3 3"/>
                        <path d="M3 12c1 0 3-1 3-3s-2-3-3-3-3 1-3 3 2 3 3 3"/>
                        <path d="M13 12h3"/>
                        <path d="M5 12h3"/>
                    </svg>
                    <select 
                        id="role" 
                        name="role" 
                        class="form-select"
                        required
                    >
                        <option value="">Select user role</option>
                        <option value="Admin" ${user != null && user.role == 'Admin' ? 'selected' : ''}>Administrator</option>
                        <option value="Staff" ${user != null && user.role == 'Staff' ? 'selected' : ''}>Staff Member</option>
                    </select>
                </div>
                <div class="form-hint">Determines system access level and permissions</div>
                <div id="roleIndicator" class="role-badge" style="display: none;"></div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/>
                        <polyline points="17,21 17,13 7,13 7,21"/>
                        <polyline points="7,3 7,8 15,8"/>
                    </svg>
                    <c:choose>
                        <c:when test="${user != null}">Update User</c:when>
                        <c:otherwise>Create User</c:otherwise>
                    </c:choose>
                </button>
                
                <a href="${pageContext.request.contextPath}/UserController?action=list" class="btn btn-secondary">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M19 12H6m6-7-7 7 7 7"/>
                    </svg>
                    Cancel
                </a>
            </div>
        </form>

        <a href="${pageContext.request.contextPath}/UserController?action=list" class="back-link">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 12H6m6-7-7 7 7 7"/>
            </svg>
            Back to User List
        </a>
    </div>

    <script>
        // Form validation and loading states
        document.getElementById('userForm').addEventListener('submit', function(e) {
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

        // Password strength indicator
        document.getElementById('password').addEventListener('input', function(e) {
            const password = e.target.value;
            const strengthIndicator = document.getElementById('passwordStrength');
            
            if (password.length > 0) {
                strengthIndicator.style.display = 'block';
                
                let strength = 0;
                let feedback = '';
                
                // Length check
                if (password.length >= 8) strength++;
                if (password.length >= 12) strength++;
                
                // Character variety checks
                if (/[a-z]/.test(password)) strength++;
                if (/[A-Z]/.test(password)) strength++;
                if (/[0-9]/.test(password)) strength++;
                if (/[^A-Za-z0-9]/.test(password)) strength++;
                
                if (strength <= 2) {
                    strengthIndicator.className = 'password-strength strength-weak';
                    feedback = 'Weak password';
                } else if (strength <= 4) {
                    strengthIndicator.className = 'password-strength strength-medium';
                    feedback = 'Medium strength password';
                } else {
                    strengthIndicator.className = 'password-strength strength-strong';
                    feedback = 'Strong password';
                }
                
                strengthIndicator.textContent = feedback;
            } else {
                strengthIndicator.style.display = 'none';
            }
        });

        // Role indicator
        document.getElementById('role').addEventListener('change', function(e) {
            const role = e.target.value;
            const indicator = document.getElementById('roleIndicator');
            
            if (role) {
                indicator.style.display = 'inline-block';
                
                if (role === 'Admin') {
                    indicator.className = 'role-badge role-admin';
                    indicator.textContent = 'Full System Access';
                } else if (role === 'Staff') {
                    indicator.className = 'role-badge role-staff';
                    indicator.textContent = 'Limited Access';
                }
            } else {
                indicator.style.display = 'none';
            }
        });

        // Form field animations
        document.querySelectorAll('.form-input, .form-select').forEach(input => {
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

        // Username validation
        document.getElementById('username').addEventListener('input', function(e) {
            const username = e.target.value;
            // Remove any invalid characters (basic validation)
            e.target.value = username.replace(/[^a-zA-Z0-9_.-]/g, '');
        });

        // Initialize indicators if editing
        window.addEventListener('DOMContentLoaded', function() {
            const roleSelect = document.getElementById('role');
            if (roleSelect.value) {
                roleSelect.dispatchEvent(new Event('change'));
            }
        });
    </script>
</body>
</html>