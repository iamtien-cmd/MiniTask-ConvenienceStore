<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="LHT.model.Order"%>
<%@ include file="../components/admin/header.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Manage Orders</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }

        .container {
            max-width: 1200px;
            margin: 120px auto;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        h1 {
            color: #333;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #333;
            color: white;
            padding: 15px;
            text-align: left;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }

        tr:hover {
            background: #f9f9f9;
        }

        .status {
            padding: 8px 12px;
            border-radius: 5px;
            font-weight: bold;
            color: white;
        }

        .status-pending {
            background: #ff9800;
        }

        .status-confirmed {
            background: #4CAF50;
        }

        .status-shipped {
            background: #2196F3;
        }

        .status-delivered {
            background: #8BC34A;
        }

        .status-cancelled {
            background: #f44336;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
        }

        .btn-update {
            background: #2196F3;
            color: white;
        }

        .btn-update:hover {
            background: #0b7dda;
        }

        .btn-cancel {
            background: #f44336;
            color: white;
        }

        .btn-cancel:hover {
            background: #da190b;
        }
    </style>
</head>

<body>

<%@ include file="../components/header.jsp"%>

<div class="container">
    <h1>📋 Manage Orders</h1>

    <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
    %>

    <table>
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Customer ID</th>
                <th>Order Date</th>
                <th>Total Amount</th>
                <th>Status</th>
                <th>Payment Method</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (orders != null && !orders.isEmpty()) {
                    for (Order order : orders) {
                        String statusClass = "";
                        switch (order.getStatus()) {
                            case "PENDING":
                                statusClass = "status-pending";
                                break;
                            case "CONFIRMED":
                                statusClass = "status-confirmed";
                                break;
                            case "SHIPPED":
                                statusClass = "status-shipped";
                                break;
                            case "DELIVERED":
                                statusClass = "status-delivered";
                                break;
                            case "CANCELLED":
                                statusClass = "status-cancelled";
                                break;
                        }
            %>
            <tr>
                <td><strong>#<%= order.getOrderId() %></strong></td>
                <td><%= order.getCustomerId() %></td>
                <td><%= order.getOrderDate() %></td>
                <td>$<%= String.format("%.2f", order.getTotalAmount()) %></td>
                <td><span class="status <%= statusClass %>"><%= order.getStatus() %></span></td>
                <td><%= order.getPaymentMethod() %></td>
                <td>
                    <div class="action-buttons">
                        <form method="POST" action="<%= request.getContextPath() %>/admin/orders" style="display: inline;">
                            <input type="hidden" name="action" value="update-status">
                            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                            <select name="status">
                                 <option value="PENDING" <%= order.getStatus().equals("PENDING") ? "selected" : "" %>>Pending</option>
                                 <option value="CONFIRMED" <%= order.getStatus().equals("CONFIRMED") ? "selected" : "" %>>Confirmed</option>
                                 <option value="SHIPPED" <%= order.getStatus().equals("SHIPPED") ? "selected" : "" %>>Shipped</option>
                                 <option value="DELIVERED" <%= order.getStatus().equals("DELIVERED") ? "selected" : "" %>>Delivered</option>
                             </select>
                            <button type="submit" class="btn btn-update">Update</button>
                        </form>
                        <form method="POST" action="<%= request.getContextPath() %>/admin/orders" style="display: inline;">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                            <button type="submit" class="btn btn-cancel" onclick="return confirm('Cancel this order?')">Cancel Order</button>
                        </form>
                    </div>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </tbody>
    </table>
</div>

<style>
    select {
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 12px;
    }
</style>

</body>
</html>
