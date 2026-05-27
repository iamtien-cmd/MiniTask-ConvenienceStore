<%@ page contentType="text/html;charset=UTF-8" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>

    <link rel="stylesheet" href="css/style.css">

    <style>
        .register-container{
            width:450px;
            background:white;
            padding:40px;
            border-radius:20px;
            box-shadow:0 10px 30px rgba(0,0,0,0.2);
            margin:140px auto;
        }

        .register-title{
            text-align:center;
            color:#ff6b00;
            margin-bottom:30px;
            font-size:36px;
        }

        .form-group{
            margin-bottom:20px;
        }

        .form-group label{
            display:block;
            margin-bottom:8px;
            font-weight:bold;
            color:#444;
        }

        .form-group input{
            width:100%;
            padding:14px;
            border:1px solid #ccc;
            border-radius:10px;
            font-size:16px;
            transition:0.3s;
        }

        .form-group input:focus{
            border-color:#ff6b00;
            outline:none;
            box-shadow:0 0 5px rgba(255,107,0,0.5);
        }

        .error-text{
            color:red;
            font-size:13px;
            margin-top:5px;
            display:block;
        }

        .register-btn{
            width:100%;
            padding:15px;
            border:none;
            background:#ff6b00;
            color:white;
            font-size:18px;
            border-radius:10px;
            cursor:pointer;
            transition:0.3s;
        }

        .register-btn:hover{
            background:#ff8c33;
        }

        .login-link{
            margin-top:20px;
            text-align:center;
        }

        .login-link a{
            color:#ff6b00;
            text-decoration:none;
            font-weight:bold;
        }
    </style>
</head>

<body>

<%@ include file="components/header.jsp" %>

<div class="register-container">

    <h1 class="register-title">Register</h1>

    <form action="register" method="post">

        <!-- FULL NAME -->
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="fullName"
                   placeholder="Enter full name"
                   value="${param.fullName}"
                   required>

            <c:if test="${not empty nameError}">
                <span class="error-text">${nameError}</span>
            </c:if>
        </div>

        <!-- EMAIL -->
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email"
                   placeholder="Enter email"
                   value="${param.email}"
                   required>

            <c:if test="${not empty emailError}">
                <span class="error-text">${emailError}</span>
            </c:if>
        </div>

        <!-- PASSWORD -->
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password"
                   placeholder="Enter password"
                   required>

            <c:if test="${not empty passError}">
                <span class="error-text">${passError}</span>
            </c:if>
        </div>

        <!-- ADDRESS -->
        <div class="form-group">
            <label>Address</label>
            <input type="text" name="address"
                   placeholder="Enter address"
                   value="${param.address}"
                   required>

            <c:if test="${not empty addressError}">
                <span class="error-text">${addressError}</span>
            </c:if>
        </div>

        <button type="submit" class="register-btn">
            Register
        </button>

    </form>

    <div class="login-link">
        Already have an account?
        <a href="login.jsp">Login</a>
    </div>

</div>

</body>
</html>