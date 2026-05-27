<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="LHT.model.Order" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>My Orders - 7-Eleven Store</title>

    <link rel="stylesheet" href="css/style.css">

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
            max-width: 1100px;
            margin: 120px auto;
            padding: 30px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .page-header h1 {
            font-size: 42px;
            color: #ff6b00;
            margin-bottom: 10px;
        }

        .page-header p {
            color: #777;
            font-size: 16px;
        }

        .orders-grid {
            display: grid;
            gap: 20px;
        }

        .order-card {
            background: white;
            border-radius: 18px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: 0.3s;
            border-left: 6px solid #ff6b00;
        }

        .order-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }

        .order-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .order-id {
            font-size: 24px;
            font-weight: bold;
            color: #ff6b00;
            text-decoration: none;
        }

        .order-id:hover {
            text-decoration: underline;
        }

        .status {
            padding: 8px 16px;
            border-radius: 30px;
            font-size: 14px;
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

        .order-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
        }

        .info-box {
            background: #fff5ec;
            padding: 15px;
            border-radius: 12px;
        }

        .info-label {
            font-size: 13px;
            color: #888;
            margin-bottom: 8px;
            text-transform: uppercase;
        }

        .info-value {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .order-actions {
            margin-top: 25px;
            display: flex;
            justify-content: flex-end;
        }

        .btn {
            display: inline-block;
            padding: 12px 18px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
        }

        .btn-primary {
            background: #ff6b00;
            color: white;
        }

        .btn-primary:hover {
            background: #ff8c33;
        }

        .btn-secondary {
            border: 2px solid #ff6b00;
            color: #ff6b00;
            background: white;
        }

        .btn-secondary:hover {
            background: #ff6b00;
            color: white;
        }

        .empty {
            background: white;
            padding: 80px 30px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        .empty h2 {
            color: #ff6b00;
            margin-bottom: 15px;
            font-size: 32px;
        }

        .empty p {
            color: #777;
            margin-bottom: 30px;
        }

        .pagination {
            margin-top: 40px;
            display: flex;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .pagination a,
        .pagination span {
            min-width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
        }

        .pagination a {
            background: white;
            color: #ff6b00;
            border: 2px solid #ff6b00;
        }

        .pagination a:hover {
            background: #ff6b00;
            color: white;
        }

        .pagination .current {
            background: #ff6b00;
            color: white;
        }

        .bottom-actions {
            margin-top: 40px;
            text-align: center;
        }

    </style>

</head>

<body>

<%@ include file="components/header.jsp"%>

<div class="container">

    <div class="page-header">

        <h1>📦 My Orders</h1>

        <p>
            Track your recent purchases and order status
        </p>

    </div>

<%
    List<Order> orders =
        (List<Order>) request.getAttribute("orders");

    Integer currentPage =
        (Integer) request.getAttribute("currentPage");

    Integer totalPages =
        (Integer) request.getAttribute("totalPages");

    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
%>

<%
    if (orders == null || orders.isEmpty()) {
%>

    <div class="empty">

        <h2>No Orders Yet</h2>

        <p>
            You haven't placed any orders yet.
        </p>

        <a href="products"
           class="btn btn-primary">

            Start Shopping

        </a>

    </div>

<%
    } else {
%>

<div class="orders-grid">

<%
    for (Order order : orders) {

        String status =
            order.getStatus() != null
            ? order.getStatus().toLowerCase()
            : "pending";
%>

    <div class="order-card">

        <div class="order-top">

            <a class="order-id"
               href="<%=request.getContextPath()%>/order-details?orderId=<%=order.getOrderId()%>">

                Order #<%=order.getOrderId()%>

            </a>

            <span class="status status-<%=status%>">

                <%= order.getStatus() %>

            </span>

        </div>

        <div class="order-info">

            <div class="info-box">

                <div class="info-label">
                    Order Date
                </div>

                <div class="info-value">
                    <%= order.getOrderDate() != null
                        ? order.getOrderDate()
                        : "N/A" %>
                </div>

            </div>

            <div class="info-box">

                <div class="info-label">
                    Total Amount
                </div>

                <div class="info-value">
                    $<%= String.format("%.2f",
                        order.getTotalAmount()) %>
                </div>

            </div>

            <div class="info-box">

                <div class="info-label">
                    Payment Method
                </div>

                <div class="info-value">
                    <%= order.getPaymentMethod() != null
                        ? order.getPaymentMethod()
                        : "N/A" %>
                </div>

            </div>

        </div>

        <div class="order-actions">

            <a href="<%=request.getContextPath()%>/order-details?orderId=<%=order.getOrderId()%>"
               class="btn btn-primary">

                View Details

            </a>

        </div>

    </div>

<%
    }
%>

</div>

<div class="pagination">

<%
    if (totalPages > 1) {

        if (currentPage > 1) {
%>

    <a href="?page=<%=currentPage - 1%>">
        ←
    </a>

<%
        }

        for (int p = 1; p <= totalPages; p++) {

            if (p == currentPage) {
%>

    <span class="current">
        <%=p%>
    </span>

<%
            } else {
%>

    <a href="?page=<%=p%>">
        <%=p%>
    </a>

<%
            }
        }

        if (currentPage < totalPages) {
%>

    <a href="?page=<%=currentPage + 1%>">
        →
    </a>

<%
        }
    }
%>

</div>

<%
    }
%>

<div class="bottom-actions">

    <a href="products"
       class="btn btn-secondary">

        Continue Shopping

    </a>

</div>

</div>

</body>
</html>