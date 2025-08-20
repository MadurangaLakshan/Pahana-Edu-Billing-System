<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${user != null}">Update User</c:when><c:otherwise>Add User</c:otherwise></c:choose></title>
    <style>
        /* Reuse your form styles from item-form.jsp or include them via CSS file */
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 1rem;
        }
        .form-container {
            background: #fff;
            border-radius: 1rem;
            padding: 2rem;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .form-label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-input, .form-select { width: 100%; padding: 0.75rem; margin-bottom: 1rem; border-radius: 0.5rem; border: 1px solid #ccc; }
        .form-actions { display: flex; justify-content: space-between; }
        .btn { padding: 0.75rem 1.5rem; border-radius: 0.5rem; border: none; cursor: pointer; font-weight: 500; }
        .btn-primary { background: #3b82f6; color: white; }
        .btn-secondary { background: #e5e7eb; color: #111; }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>
            <c:choose>
                <c:when test="${user != null}">Update User</c:when>
                <c:otherwise>Add User</c:otherwise>
            </c:choose>
        </h1>
        <form action="${pageContext.request.contextPath}/UserController" method="post">
            <input type="hidden" name="action" value="save"/>
            
            <c:if test="${user != null}">
                <input type="hidden" name="userId" value="${user.userId}"/>
            </c:if>

            <label class="form-label" for="username">Username <span style="color:red">*</span></label>
            <input type="text" class="form-input" id="username" name="username"
                   value="${user != null ? user.username : ''}" placeholder="Enter username" required />

            <label class="form-label" for="password">
                Password <c:if test="${user == null}"><span style="color:red">*</span></c:if>
            </label>
            <input type="password" class="form-input" id="password" name="password"
                   placeholder="${user != null ? 'Leave blank to keep current password' : 'Enter password'}"
                   <c:if test="${user == null}">required</c:if> />

            <label class="form-label" for="role">Role <span style="color:red">*</span></label>
            <select class="form-select" id="role" name="role" required>
                <option value="">Select role</option>
                <option value="Admin" ${user != null && user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                <option value="Staff" ${user != null && user.role == 'Staff' ? 'selected' : ''}>Staff</option>
            </select>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${user != null}">Update User</c:when>
                        <c:otherwise>Create User</c:otherwise>
                    </c:choose>
                </button>
                <a href="${pageContext.request.contextPath}/UserController?action=list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</body>
</html>
