<%@ page import="LHT.model.User"%>

<%
User user = (User) session.getAttribute("user");
%>

<div class="header">

	<div class="logo">7-Eleven Store</div>

	<div class="nav">

		<a href="index.jsp"> Home </a> <a href="products"> Products </a>

		<%
		if (user == null) {
		%>

		<a href="login.jsp"> Login </a> <a href="register.jsp"
			class="register-btn"> Register </a>

		<%
		} else {
		%>

		<span style="color: white; font-weight: bold;"> Hi, <%=user.getFullName()%>

		</span> <a href="cart"> Cart (<%=session.getAttribute("cartCount") != null ? session.getAttribute("cartCount") : 0%>)
		</a> <a href="my-orders"> My Orders </a>

		<%
		// Admin links (null-safe)
		Long roleId = user.getRoleId();
		if (roleId != null && roleId.longValue() == 2L) {
		%>

        		<a href="<%= request.getContextPath() %>/admin/products"> Admin Products </a> <a href="<%= request.getContextPath() %>/admin/orders"> Admin Orders </a>

		<%
		}
		%>

		<a href="logout"> Logout </a>

		<%
		}
		%>

	</div>

</div>