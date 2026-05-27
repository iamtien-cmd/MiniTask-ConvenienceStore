<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="LHT.model.Order" %>
<%@ page import="LHT.dto.OrderDetailDTO" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Details - 7-Eleven Store</title>

    <link rel="stylesheet" href="css/style.css">

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
        }

        body{
            font-family:Arial, sans-serif;
            background:#f5f5f5;
            color:#333;
        }

        .container{
            max-width:1100px;
            margin:120px auto 50px;
            background:white;
            border-radius:20px;
            padding:40px;
            box-shadow:0 8px 25px rgba(0,0,0,0.08);
        }

        .page-title{
            text-align:center;
            margin-bottom:40px;
        }

        .page-title h1{
            color:#ff6b00;
            font-size:36px;
            margin-bottom:10px;
        }

        .page-title p{
            color:#777;
        }

        .order-summary{
            display:grid;
            grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
            gap:20px;
            margin-bottom:30px;
        }

        .summary-card{
            background:#fff7f0;
            padding:20px;
            border-radius:15px;
            border:1px solid #ffe0cc;
        }

        .summary-card h3{
            font-size:14px;
            color:#888;
            margin-bottom:10px;
        }

        .summary-card p{
            font-size:18px;
            font-weight:bold;
            color:#222;
            word-break:break-word;
        }

        .status{
            display:inline-block;
            padding:8px 15px;
            border-radius:20px;
            color:white;
            font-size:14px;
            font-weight:bold;
        }

        .status-pending{
            background:#ff9800;
        }

        .status-confirmed{
            background:#4CAF50;
        }

        .status-shipped{
            background:#2196F3;
        }

        .status-delivered{
            background:#8BC34A;
        }

        .status-cancelled{
            background:#f44336;
        }

        .delivery-box{
            margin-bottom:40px;
            padding:25px;
            background:#fff7f0;
            border-radius:15px;
            border:1px solid #ffd7bd;
        }

        .delivery-box p{
            margin:12px 0;
            font-size:16px;
        }

        .section-title{
            font-size:24px;
            margin-bottom:20px;
            color:#ff6b00;
        }

        table{
            width:100%;
            border-collapse:collapse;
            overflow:hidden;
            border-radius:15px;
        }

        thead{
            background:#ff6b00;
            color:white;
        }

        th{
            padding:18px;
            text-align:left;
            font-size:15px;
        }

        td{
            padding:18px;
            border-bottom:1px solid #eee;
        }

        tbody tr:hover{
            background:#fff7f0;
            transition:0.2s;
        }

        .product-name{
            font-weight:bold;
            color:#333;
        }

        .price{
            text-align:right;
        }

        .empty{
            text-align:center;
            padding:40px;
            color:#999;
        }

        .bottom-action{
            text-align:center;
            margin-top:40px;
        }

        .btn{
            display:inline-block;
            padding:14px 28px;
            background:#ff6b00;
            color:white;
            text-decoration:none;
            border-radius:10px;
            font-weight:bold;
            transition:0.3s;
        }

        .btn:hover{
            background:#ff8533;
            transform:translateY(-2px);
        }

        @media(max-width:768px){

            .container{
                padding:20px;
            }

            th, td{
                padding:12px;
                font-size:14px;
            }

            .page-title h1{
                font-size:28px;
            }
        }

    </style>
</head>

<body>

<%@ include file="components/header.jsp" %>

<%
    Order order =
            (Order) request.getAttribute("order");

    List<OrderDetailDTO> items =
            (List<OrderDetailDTO>) request.getAttribute("items");

    if(items == null){
        items = new java.util.ArrayList<>();
    }

    String statusClass = "status-pending";

    if(order != null && order.getStatus() != null){

        switch(order.getStatus().toUpperCase()){

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
    }

    OrderDetailDTO firstItem = null;

    if(!items.isEmpty()){
        firstItem = items.get(0);
    }
%>

<div class="container">

    <div class="page-title">
        <h1>📦 Order Details</h1>
        <p>Track your order and purchased items</p>
    </div>

    <!-- ORDER SUMMARY -->

    <div class="order-summary">

        <div class="summary-card">
            <h3>Order ID</h3>
            <p>
                #<%= order.getOrderId() %>
            </p>
        </div>

        <div class="summary-card">
            <h3>Order Date</h3>
            <p>
                <%= order.getOrderDate() == null
                        ? "N/A"
                        : order.getOrderDate() %>
            </p>
        </div>

        <div class="summary-card">
            <h3>Total Amount</h3>
            <p>
                $<%= String.format("%.2f",
                        order.getTotalAmount()) %>
            </p>
        </div>

        <div class="summary-card">
            <h3>Status</h3>

            <span class="status <%= statusClass %>">
                <%= order.getStatus() %>
            </span>
        </div>

        <div class="summary-card">
            <h3>Payment Method</h3>

            <p>
                <%= order.getPaymentMethod() == null
                        ? "N/A"
                        : order.getPaymentMethod() %>
            </p>
        </div>

    </div>

    <!-- DELIVERY INFO -->

    <div class="delivery-box">

        <h2 class="section-title">
            🚚 Delivery Information
        </h2>

        <p>
            <strong>Recipient Name:</strong>

            <%= firstItem != null
                    ? firstItem.getRecipientName()
                    : "N/A" %>
        </p>

        <p>
            <strong>Phone Number:</strong>

            <%= firstItem != null
                    ? firstItem.getPhoneNumber()
                    : "N/A" %>
        </p>

        <p>
            <strong>Delivery Address:</strong>

            <%= firstItem != null
                    ? firstItem.getAddress()
                    : "N/A" %>
        </p>

    </div>

    <!-- ITEMS -->

    <h2 class="section-title">
        🛒 Purchased Items
    </h2>

    <table>

        <thead>

        <tr>
            <th>Product</th>
            <th class="price">Unit Price</th>
            <th class="price">Quantity</th>
            <th class="price">Total</th>
        </tr>

        </thead>

        <tbody>

        <%
            if(items.isEmpty()){
        %>

        <tr>
            <td colspan="4" class="empty">
                No items found for this order.
            </td>
        </tr>

        <%
            } else {

                for(OrderDetailDTO it : items){
        %>

        <tr>

            <td class="product-name">
                <%= it.getProductName() %>
            </td>

            <td class="price">
                $<%= String.format("%.2f",
                        it.getUnitPrice()) %>
            </td>

            <td class="price">
                <%= it.getQuantity() %>
            </td>

            <td class="price">
                $<%= String.format("%.2f",
                        it.getTotalPrice()) %>
            </td>

        </tr>

        <%
                }
            }
        %>

        </tbody>

    </table>

    <div class="bottom-action">

        <a href="my-orders" class="btn">
            ← Back To Orders
        </a>

    </div>

</div>

</body>
</html>