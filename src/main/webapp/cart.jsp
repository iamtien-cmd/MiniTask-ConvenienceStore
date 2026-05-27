<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="LHT.model.CartItem"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Your Cart - 7-Eleven Store</title>

    <link rel="stylesheet" href="css/style.css">

    <style>

        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
        }

        .container {
            max-width: 1000px;
            margin: 120px auto;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        h1 {
            text-align: center;
            color: #ff6b00;
            margin-bottom: 30px;
            font-size: 36px;
        }

        .cart-table {
            width: 100%;
            border-collapse: collapse;
        }

        .cart-table th {
            background: #ff6b00;
            color: white;
            padding: 15px;
            text-align: left;
        }

        .cart-table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }

        .cart-table tr:hover {
            background: #fff5ec;
        }

        .price-cell {
            color: #ff6b00;
            font-weight: bold;
        }

        .quantity-display {
            width: 80px;
            padding: 8px;
            text-align: center;
            border: 2px solid #ff6b00;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
        }

        .remove-btn {
            background: red;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        .remove-btn:hover {
            background: darkred;
        }

        .summary {
            margin-top: 30px;
            background: #fff5ec;
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #ff6b00;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .summary-row.total {
            font-size: 20px;
            font-weight: bold;
            color: #ff6b00;
            border-top: 2px solid #ff6b00;
            padding-top: 10px;
        }

        .actions {
            margin-top: 20px;
            text-align: center;
        }

        .btn {
            padding: 12px 20px;
            border-radius: 8px;
            text-decoration: none;
            display: inline-block;
            font-weight: bold;
            margin: 0 10px;
        }

        .btn-primary {
            background: #ff6b00;
            color: white;
            border: none;
            cursor: pointer;
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
            text-align: center;
            padding: 60px;
        }

        .empty h2 {
            color: #ff6b00;
        }

        .success-message {
            background: #4CAF50;
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: none;
        }

        .error-message {
            background: #f44336;
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: none;
        }

    </style>

</head>

<body>

<%@ include file="components/header.jsp"%>

<div class="container">

    <h1>🛒 Your Cart</h1>

    <div id="successMessage" class="success-message"></div>
    <div id="errorMessage" class="error-message"></div>

<%
    List<CartItem> cartItems =
            (List<CartItem>) request.getAttribute("cartItems");

    Double totalPrice =
            (Double) request.getAttribute("totalPrice");
%>

<%
    if (cartItems == null || cartItems.isEmpty()) {
%>

<div class="empty">

    <h2>Your cart is empty</h2>

    <p>Let's go shopping!</p>

    <a href="products"
       class="btn btn-primary">

        Shop Now

    </a>

</div>

<%
    } else {
%>

<form id="cartForm"
      action="checkout"
      method="get">

<input type="hidden"
       name="fromCart"
       value="1">

<table class="cart-table">

    <thead>

        <tr>
            <th>Select</th>
            <th>Product</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Subtotal</th>
            <th>Action</th>
        </tr>

    </thead>

    <tbody id="cartItems">

<%
    for (CartItem item : cartItems) {
%>

<tr data-cart-item-id="<%= item.getCartItemId() %>">

    <td>

        <input type="checkbox"
               name="selectedItem"
               value="<%= item.getCartItemId() %>"
               checked>

    </td>

    <td>

        <%= item.getProduct().getProductName() %>

    </td>

    <td class="price-cell">

        $<%= String.format("%.2f",
                item.getProduct().getPrice()) %>

    </td>

    <td>

        <input
            type="number"
            class="quantity-display"
            min="1"
            step="1"
            inputmode="numeric"
            pattern="[0-9]*"
            value="<%= item.getQuantity() %>"
        >

    </td>

    <td class="price-cell subtotal">

        $<%= String.format("%.2f",
                item.getProduct().getPrice()
                * item.getQuantity()) %>

    </td>

    <td>

        <button type="button"
                class="remove-btn"
                data-cart-item-id="<%= item.getCartItemId() %>">

            Remove

        </button>

    </td>

</tr>

<%
    }
%>

    </tbody>

</table>

<div class="summary">

    <div class="summary-row">

        <span>Subtotal</span>

        <span id="subtotal">

            $<%= String.format("%.2f", totalPrice) %>

        </span>

    </div>

    <div class="summary-row">

        <span>Shipping</span>

        <span id="shipping">$5.00</span>

    </div>

    <div class="summary-row total">

        <span>Total</span>

        <span id="total">

            $<%= String.format("%.2f",
                    totalPrice + 5) %>

        </span>

    </div>

</div>

<div class="actions">

    <a href="products"
       class="btn btn-secondary">

        Continue Shopping

    </a>

    <button class="btn btn-primary"
            type="submit">

        Checkout

    </button>

</div>

</form>

<%
    }
%>

</div>

<script>

    const SHIPPING_FEE = 5.00;

    function updateSummary() {

        let subtotal = 0;

        document.querySelectorAll('#cartItems tr')
            .forEach(row => {

            const checkbox =
                row.querySelector(
                    'input[name="selectedItem"]'
                );

            if (!checkbox.checked) {
                return;
            }

            const unitPrice =
                parseFloat(
                    row.querySelector(
                        'td.price-cell'
                    ).innerText.replace('$', '')
                ) || 0;

            const qty =
                parseInt(
                    row.querySelector(
                        '.quantity-display'
                    ).value
                ) || 0;

            subtotal += unitPrice * qty;

        });

        subtotal =
            Math.round(subtotal * 100) / 100;

        const shipping =
            subtotal > 0
            ? SHIPPING_FEE
            : 0;

        const total =
            subtotal + shipping;

        document.getElementById('subtotal')
            .textContent =
                '$' + subtotal.toFixed(2);

        document.getElementById('shipping')
            .textContent =
                '$' + shipping.toFixed(2);

        document.getElementById('total')
            .textContent =
                '$' + total.toFixed(2);
    }

    // checkbox update

    document.querySelectorAll(
        'input[name="selectedItem"]'
    ).forEach(cb => {

        cb.addEventListener('change', () => {

            updateSummary();

        });

    });

    // quantity input

    document.querySelectorAll('.quantity-display')
        .forEach(input => {

        input.addEventListener('input', function() {

            this.value =
                this.value.replace(/[^0-9]/g, '');

        });

        input.addEventListener('change', function() {

            let value =
                parseInt(this.value);

            if (isNaN(value) || value < 1) {
                value = 1;
            }

            if (value > 999) {
                value = 999;
            }

            this.value = value;

            const row =
                this.closest('tr');

            const cartItemId =
                row.dataset.cartItemId;

            updateQuantity(
                cartItemId,
                value
            );

        });

    });

    // remove item

    document.querySelectorAll('.remove-btn')
        .forEach(btn => {

        btn.addEventListener('click', function() {

            const cartItemId =
                this.dataset.cartItemId;

            removeFromCart(cartItemId);

        });

    });

    function updateQuantity(
        cartItemId,
        newQuantity
    ) {

        fetch(
            '${pageContext.request.contextPath}/cart',
            {
                method: 'POST',

                headers: {
                    'Content-Type':
                        'application/x-www-form-urlencoded'
                },

                body:
                    'action=update'
                    + '&cartItemId=' + cartItemId
                    + '&quantity=' + newQuantity
            }
        )

        .then(res => res.json())

        .then(data => {

            if (data.success) {

                const row =
                    document.querySelector(
                        `[data-cart-item-id="${cartItemId}"]`
                    );

                const unitPrice =
                    parseFloat(
                        row.querySelector(
                            'td.price-cell'
                        ).innerText.replace('$','')
                    );

                row.querySelector(
                    '.subtotal'
                ).textContent =
                    '$'
                    + (unitPrice * newQuantity)
                        .toFixed(2);

                updateSummary();

                showSuccess(
                    "Updated successfully"
                );

            } else {

                showError(
                    "Update failed"
                );

            }

        });

    }

    function removeFromCart(cartItemId) {

        if (!confirm("Remove item?")) {
            return;
        }

        fetch(
            '${pageContext.request.contextPath}/cart',
            {
                method: 'POST',

                headers: {
                    'Content-Type':
                        'application/x-www-form-urlencoded'
                },

                body:
                    'action=remove'
                    + '&cartItemId=' + cartItemId
            }
        )

        .then(res => res.json())

        .then(data => {

            if (data.success) {

                document.querySelector(
                    `[data-cart-item-id="${cartItemId}"]`
                ).remove();

                updateSummary();

                showSuccess(
                    "Item removed"
                );

            } else {

                showError(
                    "Remove failed"
                );

            }

        });

    }

    function showSuccess(message) {

        const div =
            document.getElementById(
                'successMessage'
            );

        div.textContent = message;

        div.style.display = 'block';

        setTimeout(() => {

            div.style.display = 'none';

        }, 3000);
    }

    function showError(message) {

        const div =
            document.getElementById(
                'errorMessage'
            );

        div.textContent = message;

        div.style.display = 'block';

        setTimeout(() => {

            div.style.display = 'none';

        }, 3000);
    }

    document.addEventListener(
        'DOMContentLoaded',
        function() {

            updateSummary();

        }
    );

</script>

</body>
</html>