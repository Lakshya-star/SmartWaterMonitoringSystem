<%@ page import="java.util.List" %>
<%@ page import="com.smartwater.model.MonthlyUsageSummary" %>
<%@ page import="com.smartwater.model.WaterUsage" %>
<%@ page import="com.smartwater.model.Building" %>
<%@ page import="com.smartwater.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Smart Water</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<%
    Building building = (Building) request.getAttribute("building");
    Double currentTotal = (Double) request.getAttribute("currentTotal");
    Double previousTotal = (Double) request.getAttribute("previousTotal");
    Boolean overUsage = (Boolean) request.getAttribute("overUsage");
    String tip = (String) request.getAttribute("tip");
    Double weekTotal = (Double) request.getAttribute("weekTotal");
    Double avgDaily = (Double) request.getAttribute("avgDaily");
    Double changePct = (Double) request.getAttribute("changePct");
    List<MonthlyUsageSummary> trend = (List<MonthlyUsageSummary>) request.getAttribute("trend");
    List<WaterUsage> topUsage = (List<WaterUsage>) request.getAttribute("topUsage");
    User loggedInUser = (User) session.getAttribute("loggedInUser");
%>
<div class="container">
    <div class="app-header card glass">
        <div class="nav">
            <a href="<%= request.getContextPath() %>/usage-entry"><span class="icon">+</span>Add Usage</a>
            <a href="<%= request.getContextPath() %>/usage-history"><span class="icon">=</span>Usage History</a>
            <a href="<%= request.getContextPath() %>/report"><span class="icon">#</span>Report</a>
            <% if (loggedInUser != null && "ADMIN".equalsIgnoreCase(loggedInUser.getRole())) { %>
                <a href="<%= request.getContextPath() %>/buildings"><span class="icon">*</span>Buildings</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/logout"><span class="icon">x</span>Logout</a>
            <button class="toggle-btn right" type="button" onclick="toggleTheme()">Toggle Theme</button>
        </div>
    </div>

    <div class="card">
        <h2 class="page-title">Water Usage Dashboard</h2>
        <p class="subtle">Building: <%= building == null ? "N/A" : building.getName() %></p>
        <div class="metrics">
            <div class="metric">
                <div class="label">Current Month</div>
                <div class="value"><%= String.format("%.0f", currentTotal == null ? 0 : currentTotal) %> L</div>
            </div>
            <div class="metric">
                <div class="label">Previous Month</div>
                <div class="value"><%= String.format("%.0f", previousTotal == null ? 0 : previousTotal) %> L</div>
            </div>
            <div class="metric">
                <div class="label">Threshold</div>
                <div class="value"><%= String.format("%.0f", building == null ? 0 : building.getThresholdLiters()) %> L</div>
            </div>
            <div class="metric">
                <div class="label">Last 7 Days</div>
                <div class="value"><%= String.format("%.0f", weekTotal == null ? 0 : weekTotal) %> L</div>
            </div>
            <div class="metric">
                <div class="label">Avg Daily (This Month)</div>
                <div class="value"><%= String.format("%.1f", avgDaily == null ? 0 : avgDaily) %> L</div>
            </div>
            <div class="metric">
                <div class="label">Change vs Last Month</div>
                <div class="value"><%= String.format("%.1f", changePct == null ? 0 : changePct) %>%</div>
            </div>
        </div>
        <p class="mt8">
        <% if (Boolean.TRUE.equals(overUsage)) { %>
            <span class="badge badge-danger">Warning: usage is above threshold</span>
        <% } else { %>
            <span class="badge badge-ok">Usage is within threshold</span>
        <% } %>
        </p>
        <p><strong>Saving Tip:</strong> <span class="subtle"><%= tip %></span></p>
    </div>

    <div class="card">
        <h3>Monthly Comparison (Last 6 Months)</h3>
        <canvas id="usageChart" height="110"></canvas>
        <table>
            <tr><th>Month</th><th>Total Liters</th></tr>
            <% if (trend != null) {
                for (MonthlyUsageSummary row : trend) { %>
                    <tr>
                        <td><%= row.getMonthLabel() %></td>
                        <td><%= String.format("%.2f", row.getTotalLiters()) %></td>
                    </tr>
            <%  }
            } %>
        </table>
        <div class="mini-bars">
            <% 
                double maxValue = 1;
                if (trend != null) {
                    for (MonthlyUsageSummary row : trend) {
                        if (row.getTotalLiters() > maxValue) {
                            maxValue = row.getTotalLiters();
                        }
                    }
                }
                if (trend != null) {
                    for (MonthlyUsageSummary row : trend) {
                        double width = (row.getTotalLiters() / maxValue) * 100;
            %>
            <div class="mini-bar-row">
                <span><%= row.getMonthLabel() %></span>
                <div class="mini-bar-track"><div class="mini-bar-fill" style="width: <%= String.format("%.2f", width) %>%"></div></div>
                <strong><%= String.format("%.0f", row.getTotalLiters()) %> L</strong>
            </div>
            <%      }
                } %>
        </div>
    </div>

    <div class="card">
        <h3>Top High-Usage Entries</h3>
        <table>
            <tr><th>Date</th><th>User ID</th><th>Liters</th></tr>
            <% if (topUsage != null) {
                for (WaterUsage row : topUsage) { %>
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
    if (saved) {
        setTheme(saved);
        return;
    }
    setTheme("light");
})();

const trendLabels = [
<%
if (trend != null) {
    for (int i = 0; i < trend.size(); i++) {
        MonthlyUsageSummary row = trend.get(i);
%>
    "<%= row.getMonthLabel() %>"<%= i < trend.size() - 1 ? "," : "" %>
<%
    }
}
%>
];

const trendValues = [
<%
if (trend != null) {
    for (int i = 0; i < trend.size(); i++) {
        MonthlyUsageSummary row = trend.get(i);
%>
    <%= String.format(java.util.Locale.US, "%.2f", row.getTotalLiters()) %><%= i < trend.size() - 1 ? "," : "" %>
<%
    }
}
%>
];

const chartCtx = document.getElementById("usageChart");
if (chartCtx && trendLabels.length > 0) {
    const dark = document.body.classList.contains("dark");
    new Chart(chartCtx, {
        type: "line",
        data: {
            labels: trendLabels,
            datasets: [{
                label: "Monthly Liters",
                data: trendValues,
                borderColor: "#3b82f6",
                backgroundColor: "rgba(59,130,246,0.18)",
                fill: true,
                tension: 0.35,
                pointRadius: 3
            }]
        },
        options: {
            plugins: {
                legend: {
                    labels: { color: dark ? "#e5e7eb" : "#334155" }
                }
            },
            scales: {
                x: { ticks: { color: dark ? "#e5e7eb" : "#334155" } },
                y: { ticks: { color: dark ? "#e5e7eb" : "#334155" } }
            }
        }
    });
}
</script>
</body>
</html>
