<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation - 7-Eleven Store</title>
    <link rel="stylesheet"
          href="css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            background: white;
            padding: 50px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            text-align: center;
            max-width: 500px;
        }

        .success-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        h1 {
            color: #4CAF50;
            margin-bottom: 20px;
            font-size: 32px;
        }

        .order-id {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            border: 2px solid #4CAF50;
        }

        .order-id label {
            display: block;
            color: #666;
            margin-bottom: 10px;
            font-weight: bold;
        }

        .order-id p {
            font-size: 24px;
            color: #4CAF50;
            font-weight: bold;
        }

        .message {
            color: #333;
            line-height: 1.6;
            margin: 20px 0;
        }

        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        button, a {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: #ff6b00;
            color: white;
        }

        .btn-primary:hover {
            background: #ff8c33;
        }

        .btn-secondary {
            background: #4CAF50;
            color: white;
        }

        .btn-secondary:hover {
            background: #45a049;
        }
    </style>
</head>

<body>

<div class="container">
    <div class="success-icon">✅</div>

    <h1>Order Confirmed!</h1>

    <div class="order-id">
        <label>Order ID:</label>
        <p><%= request.getAttribute("orderId") %></p>
    </div>

    <div class="message">
        <p>Thank you for your order!</p>
        <p>Your order has been successfully placed and is being processed.</p>
        <p>You will receive an email confirmation shortly.</p>
    </div>

    <div class="button-group">
        <a href="my-orders" class="btn-primary">View My Orders</a>
        <a href="products" class="btn-secondary">Continue Shopping</a>
    </div>
</div>

</body>
</html>
