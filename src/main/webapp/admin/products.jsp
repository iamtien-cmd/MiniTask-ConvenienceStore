<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="LHT.model.Product"%>
<%@ include file="../components/admin/header.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Manage Products</title>
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

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        h1 {
            color: #333;
        }

        .btn {
            padding: 10px 20px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn:hover {
            background: #45a049;
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

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-edit {
            background: #2196F3;
            padding: 8px 12px;
            font-size: 12px;
        }

        .btn-edit:hover {
            background: #0b7dda;
        }

        .btn-delete {
            background: #f44336;
            padding: 8px 12px;
            font-size: 12px;
        }

        .btn-delete:hover {
            background: #da190b;
        }
    </style>
</head>

<body>

<%@ include file="../components/header.jsp"%>

<div class="container">
    <div class="header">
        <h1>📦 Manage Products</h1>
        <a class="btn" href="${pageContext.request.contextPath}/admin/products?action=add">+ Add Product</a>
    </div>

    <%
        List<Product> products = (List<Product>) request.getAttribute("products");
    %>

    <table>
        <thead>
            <tr>
                <th>Product ID</th>
                <th>Product Name</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Description</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (products != null && !products.isEmpty()) {
                    for (Product product : products) {
            %>
            <tr>
                <td><%= product.getProductId() %></td>
                <td><%= product.getProductName() %></td>
                <td>$<%= String.format("%.2f", product.getPrice()) %></td>
                <td><%= product.getStockQuantity() %></td>
                <td><%= product.getDescription() != null ? product.getDescription() : "N/A" %></td>
                <td>
                    <div class="action-buttons">
                        <a class="btn btn-edit" href="<%= request.getContextPath() %>/admin/products?action=edit&productId=<%= product.getProductId() %>">Edit</a>
                        <form method="POST" action="<%= request.getContextPath() %>/admin/products" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                            <button type="submit" class="btn btn-delete" onclick="return confirm('Delete this product?')">Delete</button>
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

</body>
</html>
