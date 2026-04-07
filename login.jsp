<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Smart Water</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="card auth-card">
        <div class="nav">
            <button class="toggle-btn right" type="button" onclick="toggleTheme()">Toggle Theme</button>
        </div>
        <h2 class="page-title">Smart Water Login</h2>
        <p class="subtle">Track usage, analyze trends, and reduce water wastage.</p>
        <% if (request.getAttribute("error") != null) { %>
            <p class="danger"><%= request.getAttribute("error") %></p>
        <% } %>
        <form method="post" action="<%= request.getContextPath() %>/login">
            <label>Email</label>
            <input type="email" name="email" required>
            <label>Password</label>
            <input type="password" name="password" required>
            <button type="submit">Login</button>
        </form>
        <p class="mt8">No account? <a href="<%= request.getContextPath() %>/register">Register</a></p>
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
