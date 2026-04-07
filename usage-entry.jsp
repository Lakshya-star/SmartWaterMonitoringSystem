<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Usage Entry - Smart Water</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
</head>
<body>
<div class="container">
    <div class="app-header card glass">
        <div class="nav">
            <a href="<%= request.getContextPath() %>/dashboard"><span class="icon">#</span>Dashboard</a>
            <a href="<%= request.getContextPath() %>/usage-history"><span class="icon">=</span>Usage History</a>
            <a href="<%= request.getContextPath() %>/report"><span class="icon">=</span>Report</a>
            <a href="<%= request.getContextPath() %>/logout"><span class="icon">x</span>Logout</a>
            <button class="toggle-btn right" type="button" onclick="toggleTheme()">Toggle Theme</button>
        </div>
    </div>
    <div class="card">
        <h2 class="page-title">Enter Daily Water Usage</h2>
        <p class="subtle">Add today's reading in liters for quick monitoring and monthly reports.</p>
        <% if (request.getAttribute("error") != null) { %>
            <p class="danger"><%= request.getAttribute("error") %></p>
        <% } %>
        <form method="post" action="<%= request.getContextPath() %>/usage-entry">
            <label>Date</label>
            <input type="date" name="usageDate">
            <label>Liters Used</label>
            <input type="number" step="0.01" min="0" name="litersUsed" required>
            <button type="submit">Save Usage</button>
        </form>
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
