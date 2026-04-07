<%@ page import="java.util.List" %>
<%@ page import="com.smartwater.model.Building" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Smart Water</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="card auth-card">
        <div class="nav">
            <button class="toggle-btn right" type="button" onclick="toggleTheme()">Toggle Theme</button>
        </div>
        <h2 class="page-title">Create Account</h2>
        <p class="subtle">Register for your building and start logging water usage.</p>
        <% if (request.getAttribute("error") != null) { %>
            <p class="danger"><%= request.getAttribute("error") %></p>
        <% } %>
        <form method="post" action="<%= request.getContextPath() %>/register">
            <label>Name</label>
            <input type="text" name="name" required>
            <label>Email</label>
            <input type="email" name="email" required>
            <label>Password</label>
            <input type="password" name="password" required>
            <label>Building</label>
            <select name="buildingId" required>
                <%
                    List<Building> buildings = (List<Building>) request.getAttribute("buildings");
                    if (buildings != null) {
                        for (Building building : buildings) {
                %>
                <option value="<%= building.getId() %>"><%= building.getName() %> - <%= building.getLocation() %></option>
                <%
                        }
                    }
                %>
            </select>
            <button type="submit">Create Account</button>
        </form>
        <p class="mt8"><a href="<%= request.getContextPath() %>/login">Back to login</a></p>
    </div>
</div>
<script>
function setTheme(mode) {
    document.body.classList.toggle("dark", mode === "dark");
    localStorage.setItem("smartwater-theme", mode);
}
function toggleTheme() {
    const dark = document.body.classList.contains("dark");
    setTheme(dark ? "light" : "dark");
}
(function initTheme() {
    const saved = localStorage.getItem("smartwater-theme");
    setTheme(saved ? saved : "light");
})();
</script>
</body>
</html>
