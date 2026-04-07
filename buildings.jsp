<%@ page import="java.util.List" %>
<%@ page import="com.smartwater.model.Building" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Buildings - Smart Water</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
</head>
<body>
<%
    List<Building> buildings = (List<Building>) request.getAttribute("buildings");
%>
<div class="container">
    <div class="app-header card glass">
        <div class="nav">
            <a href="<%= request.getContextPath() %>/dashboard"><span class="icon">#</span>Dashboard</a>
            <a href="<%= request.getContextPath() %>/usage-history"><span class="icon">=</span>Usage History</a>
            <a href="<%= request.getContextPath() %>/logout"><span class="icon">x</span>Logout</a>
            <button class="toggle-btn right" type="button" onclick="toggleTheme()">Toggle Theme</button>
        </div>
    </div>

    <div class="card">
        <h2 class="page-title">Building Management (Admin)</h2>
        <p class="subtle">Add new buildings and thresholds for better monitoring.</p>
        <% if (request.getAttribute("error") != null) { %>
            <p class="danger"><%= request.getAttribute("error") %></p>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <p class="success"><%= request.getAttribute("success") %></p>
        <% } %>
        <form method="post" action="<%= request.getContextPath() %>/buildings">
            <label>Building Name</label>
            <input type="text" name="name" required>
            <label>Type</label>
            <input type="text" name="type" required>
            <label>Location</label>
            <input type="text" name="location" required>
            <label>Threshold (liters/month)</label>
            <input type="number" step="0.01" min="1" name="thresholdLiters" required>
            <button type="submit">Add Building</button>
        </form>
    </div>

    <div class="card">
        <h3>Existing Buildings</h3>
        <table>
            <tr><th>ID</th><th>Name</th><th>Type</th><th>Location</th><th>Threshold</th></tr>
            <% if (buildings != null) {
                for (Building row : buildings) { %>
                    <tr>
                        <td><%= row.getId() %></td>
                        <td><%= row.getName() %></td>
                        <td><%= row.getType() %></td>
                        <td><%= row.getLocation() %></td>
                        <td><%= String.format("%.0f", row.getThresholdLiters()) %> L</td>
                    </tr>
            <% }
            } %>
        </table>
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
