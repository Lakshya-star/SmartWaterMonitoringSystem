<%@ page import="java.util.List" %>
<%@ page import="com.smartwater.model.WaterUsage" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Report - Smart Water</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
</head>
<body>
<%
    String selectedMonth = (String) request.getAttribute("selectedMonth");
    List<WaterUsage> rows = (List<WaterUsage>) request.getAttribute("rows");
    Double total = (Double) request.getAttribute("total");
    Double bill = (Double) request.getAttribute("bill");
%>
<div class="container">
    <div class="app-header card glass">
        <div class="nav">
            <a href="<%= request.getContextPath() %>/dashboard"><span class="icon">#</span>Dashboard</a>
            <a href="<%= request.getContextPath() %>/usage-entry"><span class="icon">+</span>Add Usage</a>
            <a href="<%= request.getContextPath() %>/usage-history"><span class="icon">=</span>Usage History</a>
            <a href="<%= request.getContextPath() %>/logout"><span class="icon">x</span>Logout</a>
            <button class="toggle-btn right" type="button" onclick="toggleTheme()">Toggle Theme</button>
        </div>
    </div>

    <div class="card">
        <h2 class="page-title">Monthly Usage Report</h2>
        <p class="subtle">Generate monthly totals and estimated water bill instantly.</p>
        <% if (request.getAttribute("error") != null) { %>
            <p class="danger"><%= request.getAttribute("error") %></p>
        <% } %>
        <form method="get" action="<%= request.getContextPath() %>/report">
            <label>Month (YYYY-MM)</label>
            <input type="month" name="month" value="<%= selectedMonth %>">
            <button type="submit">Generate</button>
            <a class="btn" href="<%= request.getContextPath() %>/report?month=<%= selectedMonth %>&export=csv">Export CSV</a>
        </form>
        <div class="metrics">
            <div class="metric">
                <div class="label">Total Liters</div>
                <div class="value"><%= String.format("%.0f", total == null ? 0 : total) %> L</div>
            </div>
            <div class="metric">
                <div class="label">Estimated Bill</div>
                <div class="value"><%= String.format("%.2f", bill == null ? 0 : bill) %></div>
            </div>
        </div>
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
            <%  }
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
