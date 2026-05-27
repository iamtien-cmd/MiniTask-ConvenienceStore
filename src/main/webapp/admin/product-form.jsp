<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="LHT.model.Product" %>

<%
    Product product = (Product) request.getAttribute("product");
    boolean editing = product != null;
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>
        <%= editing ? "Edit Product" : "Add Product" %>
    </title>

    <%@ include file="../components/admin/header.jsp"%>

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
            max-width:700px;
            margin:120px auto;
            background:white;
            padding:40px;
            border-radius:15px;
            box-shadow:0 4px 20px rgba(0,0,0,0.1);
        }

        h1{
            text-align:center;
            margin-bottom:30px;
            color:#333;
        }

        .form-group{
            margin-bottom:20px;
        }

        label{
            display:block;
            margin-bottom:8px;
            font-weight:bold;
            color:#555;
        }

        input,
        textarea{
            width:100%;
            padding:12px;
            border:1px solid #ddd;
            border-radius:8px;
            font-size:15px;
        }

        textarea{
            resize:vertical;
            min-height:120px;
        }

        input:focus,
        textarea:focus{
            outline:none;
            border-color:#ff6b00;
        }

        .actions{
            margin-top:30px;
            display:flex;
            gap:15px;
        }

        .btn{
            padding:12px 20px;
            border:none;
            border-radius:8px;
            cursor:pointer;
            font-weight:bold;
            text-decoration:none;
            font-size:14px;
        }

        .btn-save{
            background:#4CAF50;
            color:white;
        }

        .btn-save:hover{
            background:#45a049;
        }

        .btn-cancel{
            background:#f44336;
            color:white;
        }

        .btn-cancel:hover{
            background:#d32f2f;
        }

    </style>

</head>

<body>

<div class="container">

    <h1>
        <%= editing ? "✏ Edit Product" : "➕ Add Product" %>
    </h1>

    <form method="post"
          action="<%= request.getContextPath() %>/admin/products">

        <input type="hidden"
               name="action"
               value="<%= editing ? "update" : "add" %>">

        <% if (editing) { %>

            <input type="hidden"
                   name="productId"
                   value="<%= product.getProductId() %>">

        <% } %>

        <!-- PRODUCT NAME -->

        <div class="form-group">

            <label>
                Product Name
            </label>

            <input type="text"
                   name="productName"
                   required
                   value="<%= editing ? product.getProductName() : "" %>">

        </div>

        <!-- PRICE -->

        <div class="form-group">

            <label>
                Price ($)
            </label>

            <input type="number"
                   step="0.01"
                   min="0"
                   required
                   name="price"
                   value="<%= editing ? product.getPrice() : "" %>">

        </div>

        <!-- STOCK -->

        <div class="form-group">

            <label>
                Stock Quantity
            </label>

            <input type="number"
                   min="0"
                   required
                   name="stockQuantity"
                   value="<%= editing ? product.getStockQuantity() : "" %>">

        </div>

        <!-- IMAGE URL -->

        <div class="form-group">

            <label>
                Image URL
            </label>

            <input type="text"
                   name="imageUrl"
                   value="<%= editing ? product.getImageUrl() : "" %>">

        </div>

        <!-- DESCRIPTION -->

        <div class="form-group">

            <label>
                Description
            </label>

            <textarea name="description"><%= editing ? product.getDescription() : "" %></textarea>

        </div>

        <!-- ACTIONS -->

        <div class="actions">

            <button type="submit"
                    class="btn btn-save">

                <%= editing ? "Update Product" : "Add Product" %>

            </button>

            <% if (editing) { %>
                <button type="submit" name="action" value="update" class="btn btn-cancel">Update</button>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/admin/products" class="btn btn-cancel">Cancel</a>
            <% } %>

        </div>

    </form>

</div>

</body>
</html>