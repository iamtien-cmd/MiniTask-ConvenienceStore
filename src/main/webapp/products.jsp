<%@ page import="java.util.List"%>
<%@ page import="LHT.model.Product"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Products</title>

<link rel="stylesheet" href="css/style.css">

<style>
.container {
	padding: 120px 60px;
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
	gap: 30px;
}

/* CARD */
.card {
	background: white;
	border-radius: 15px;
	overflow: visible; /* FIX QUAN TRỌNG */
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
	transition: 0.3s;

	display: flex;
	flex-direction: column;
}

.card:hover {
	transform: translateY(-5px);
}

/* IMAGE */
.card img {
	width: 100%;
	height: 220px;
	object-fit: cover;
}

/* BODY */
.card-body {
	padding: 20px;
	display: flex;
	flex-direction: column;
	flex: 1;
}

/* TEXT */
.product-name {
	font-size: 22px;
	font-weight: bold;
	margin-bottom: 10px;
	color: #333;
}

.price {
	color: #ff6b00;
	font-size: 20px;
	font-weight: bold;
	margin-bottom: 15px;
}

.description {
	color: #666;
	margin-bottom: 20px;
	min-height: 50px;
}

/* BUTTON */
.btn {
	margin-top: auto; /* đẩy xuống đáy card */
	display: inline-block;
	padding: 12px 20px;
	background: #ff6b00;
	color: white;
	text-decoration: none;
	border-radius: 8px;
	transition: 0.3s;
	text-align: center;
}

.btn:hover {
	background: #ff8c33;
}

/* TITLE */
.title {
	text-align: center;
	margin-top: 100px;
	font-size: 40px;
	color: #ff6b00;
}
</style>

</head>

<body>

<!-- HEADER -->
<%@ include file="components/header.jsp"%>

<h1 class="title">7-Eleven Products</h1>

<div class="container">

<%
    List<Product> products = (List<Product>) request.getAttribute("products");

    if (products != null) {
        for (Product p : products) {
%>

    <div class="card">

        <img src="<%=p.getImageUrl()%>">

        <div class="card-body">

            <div class="product-name">
                <%=p.getProductName()%>
            </div>

            <div class="price">
                $<%=p.getPrice()%>
            </div>

            <div class="description">
                <%=p.getDescription()%>
            </div>

            <a href="add-to-cart?productId=<%=p.getProductId()%>" class="btn">
                Add To Cart
            </a>

        </div>

    </div>

<%
        }
    }
%>

</div>

</body>
</html>