<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    .admin-header {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 70px;
        background: #222;
        color: white;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 30px;
        z-index: 1000;
        box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    }

    .admin-header .logo {
        font-size: 20px;
        font-weight: bold;
        color: #ff6b00;
    }

    .admin-header .menu {
        display: flex;
        gap: 20px;
    }

    .admin-header .menu a {
        color: white;
        text-decoration: none;
        font-weight: 500;
        padding: 8px 12px;
        border-radius: 5px;
    }

    .admin-header .menu a:hover {
        background: #ff6b00;
        color: white;
    }

    .admin-header .right {
        display: flex;
        gap: 15px;
        align-items: center;
    }

    .logout-btn {
        background: red;
        color: white;
        padding: 8px 12px;
        border-radius: 5px;
        text-decoration: none;
        font-size: 13px;
    }

    .logout-btn:hover {
        background: darkred;
    }
</style>

<div class="admin-header">

    <div class="logo">
        🛠 ADMIN PANEL
    </div>

    <div class="menu">
        <a href="${pageContext.request.contextPath}/admin/products">Products</a>
        <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users">Users</a>
    </div>

    <div class="right">
        <span>
            Admin
        </span>

        <a href="${pageContext.request.contextPath}/logout"
           class="logout-btn">
            Logout
        </a>
    </div>

</div>