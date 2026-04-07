<%@ page import="java.util.List" %>
<%@ page import="com.smartwater.model.WaterUsage" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Usage History - Smart Water</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
</head>
<body>
<%
    String from = (String) request.getAttribute("from");
    String to = (String) request.getAttribute("to");
    List<WaterUsage> rows = (List<WaterUsage>) request.getAttribute("rows");
    Double total = (Double) request.getAttribute("total");
%>
<div class="container">
    <div class="app-header card glass">
        <div class="nav">
            <a href="<%= request.getContextPath() %>/dashboard"><span class="icon">#</span>Dashboard</a>
            <a href="<%= request.getContextPath() %>/usage-entry"><span class="icon">+</span>Add Usage</a>
            <a href="<%= request.getContextPath() %>/report"><span class="icon">=</span>Report</a>
            <a href="<%= request.getContextPath() %>/logout"><span class="icon">x</span>Logout</a>
            <button class="toggle-btn right" type="button" onclick="toggleTheme()">Toggle Theme</button>
        </div>
    </div>

    <div class="card">
        <h2 class="page-title">Usage History</h2>
        <p class="subtle">Filter entries by date range and inspect past usage patterns.</p>
        <% if (request.getAttribute("error") != null) { %>
            <p class="danger"><%= request.getAttribute("error") %></p>
        <% } %>
        <form method="get" action="<%= request.getContextPath() %>/usage-history">
            <label>From</label>
            <input type="date" name="from" value="<%= from %>">
            <label>To</label>
            <input type="date" name="to" value="<%= to %>">
            <button type="submit">Apply Filter</button>
        </form>
        <p><strong>Range Total:</strong> <%= String.format("%.2f", total == null ? 0 : total) %> L</p>
    </div>

    <div class="card">
        <table>
            <tr><th>Date</th><th>User ID</th><th>Liters</th></tr>
            <% if (rows != null) {
                for (WaterUsage row : rows) { %>
                    <tr>
                        <td><%= row.getUsageDate() %></td>
                        <td><%= row.getUserId() %></td>
                        <td><%= String.format("%.2f", row.getLitersUsed()) %></td>
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
