<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="LHT.model.CartItem"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - 7-Eleven Store</title>

    <link rel="stylesheet" href="css/style.css">

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
        }

        body{
            font-family:Arial,sans-serif;
            background:#f5f5f5;
        }

        .container{
            max-width:1100px;
            margin:120px auto;
            background:white;
            padding:40px;
            border-radius:20px;
            box-shadow:0 4px 20px rgba(0,0,0,0.1);
        }

        h1{
            text-align:center;
            color:#ff6b00;
            margin-bottom:40px;
        }

        .checkout-content{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:30px;
        }

        .order-summary{
            background:#fff5ec;
            padding:25px;
            border-radius:15px;
            border:2px solid #ff6b00;
        }

        .order-summary h2{
            color:#ff6b00;
            margin-bottom:20px;
        }

        .item-row{
            display:flex;
            justify-content:space-between;
            padding:12px 0;
            border-bottom:1px solid #ddd;
        }

        .total-row{
            display:flex;
            justify-content:space-between;
            padding-top:20px;
            margin-top:15px;
            border-top:2px solid #ff6b00;
            font-size:22px;
            font-weight:bold;
            color:#ff6b00;
        }

        .payment-form{
            border:2px solid #ddd;
            border-radius:15px;
            padding:25px;
        }

        .payment-form h2{
            margin-bottom:20px;
        }

        .form-group{
            margin-bottom:20px;
        }

        label{
            display:block;
            margin-bottom:8px;
            font-weight:bold;
        }

        input[type="text"]{
            width:100%;
            padding:12px;
            border:1px solid #ddd;
            border-radius:8px;
        }

        input[type="text"]:focus{
            outline:none;
            border-color:#ff6b00;
        }

        .payment-method{
            margin:12px 0;
        }

        .confirmation{
            background:#f0f0f0;
            padding:15px;
            border-radius:10px;
            margin-top:20px;
        }

        .button-group{
            display:flex;
            gap:10px;
            margin-top:25px;
        }

        button{
            flex:1;
            padding:14px;
            border:none;
            border-radius:10px;
            font-size:16px;
            font-weight:bold;
            cursor:pointer;
        }

        .btn-confirm{
            background:#4CAF50;
            color:white;
        }

        .btn-confirm:hover{
            background:#45a049;
        }

        .btn-cancel{
            background:#f44336;
            color:white;
        }

        .btn-cancel:hover{
            background:#d32f2f;
        }

        .error{
            background:#ffebee;
            color:#c62828;
            padding:15px;
            border-radius:10px;
            margin-bottom:20px;
        }

        @media(max-width:768px){

            .checkout-content{
                grid-template-columns:1fr;
            }

            .button-group{
                flex-direction:column;
            }
        }

    </style>
</head>

<body>

<%@ include file="components/header.jsp"%>

<div class="container">

    <h1>🛒 Checkout</h1>

    <%
        List<CartItem> cartItems =
                (List<CartItem>) request.getAttribute("cartItems");

        Double totalPrice =
                (Double) request.getAttribute("totalPrice");

        String error =
                (String) request.getAttribute("error");

        if(cartItems == null){
            cartItems = new java.util.ArrayList<>();
        }

        if(totalPrice == null){
            totalPrice = 0.0;
        }

        double shipping = 5.0;

        double finalTotal = totalPrice + shipping ;
    %>

    <% if(error != null){ %>

    <div class="error">
        <%= error %>
    </div>

    <% } %>

    <form method="POST" action="checkout">

        <div class="checkout-content">

            <!-- LEFT -->
            <div class="order-summary">

                <h2>Order Summary</h2>

                <% for(CartItem item : cartItems){ %>

                <div class="item-row">

                    <span>
                        <%= item.getProduct().getProductName() %>
                        x
                        <%= item.getQuantity() %>
                    </span>

                    <span>
                        $<%= String.format(
                            "%.2f",
                            item.getProduct().getPrice()
                                    * item.getQuantity()
                    ) %>
                    </span>

                </div>

                <% } %>

                <div class="item-row">
                    <span>Subtotal</span>

                    <span>
                        $<%= String.format("%.2f", totalPrice) %>
                    </span>
                </div>

                <div class="item-row">
                    <span>Shipping</span>

                    <span>
                        $<%= String.format("%.2f", shipping) %>
                    </span>
                </div>


                <div class="total-row">

                    <span>TOTAL</span>

                    <span>
                        $<%= String.format("%.2f", finalTotal) %>
                    </span>

                </div>

            </div>

            <!-- RIGHT -->
            <div class="payment-form">

                <h2>Delivery & Payment</h2>

                <div class="form-group">

                    <label>Recipient Name</label>

                    <input type="text"
                           name="recipientName"
                           required>

                </div>

                <div class="form-group">

                    <label>Phone Number</label>

                    <input type="text"
                           name="phoneNumber"
                           required>

                </div>

                <div class="form-group">

                    <label>Delivery Address</label>

                    <input type="text"
                           name="deliveryAddress"
                           placeholder="Street, City, ZIP"
                           required>

                </div>

                <div class="form-group">

                    <label>Payment Method</label>

                    <div class="payment-method">
                        <input type="radio"
                               name="paymentMethod"
                               value="CREDIT_CARD"
                               required>

                        Credit Card
                    </div>

                    <div class="payment-method">
                        <input type="radio"
                               name="paymentMethod"
                               value="DEBIT_CARD">

                        Debit Card
                    </div>

                    <div class="payment-method">
                        <input type="radio"
                               name="paymentMethod"
                               value="PAYPAL">

                        PayPal
                    </div>

                    <div class="payment-method">
                        <input type="radio"
                               name="paymentMethod"
                               value="COD">

                        Cash On Delivery
                    </div>

                </div>

                <div class="confirmation">

                    <h3>Confirm Payment</h3>

                    <div style="margin-top:15px;">

                        <div style="margin-bottom:10px;">

                            <input type="radio"
                                   name="confirmPayment"
                                   value="yes"
                                   required>

                            YES, confirm payment

                        </div>

                        <div>

                            <input type="radio"
                                   name="confirmPayment"
                                   value="no">

                            NO, cancel order

                        </div>

                    </div>

                </div>

                <div class="button-group">

                    <button type="submit"
                            class="btn-confirm">

                        Complete Order

                    </button>

                    <a href="cart"
                       style="flex:1;">

                        <button type="button"
                                class="btn-cancel"
                                style="width:100%;">

                            Back To Cart

                        </button>

                    </a>

                </div>

            </div>

        </div>

    </form>

</div>

</body>
</html>