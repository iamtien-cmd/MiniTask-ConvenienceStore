<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Login - 7-Eleven Store</title>

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:Arial, sans-serif;
        }

        body{

            height:100vh;

            display:flex;
            justify-content:center;
            align-items:center;

            background:
            linear-gradient(
                rgba(0,0,0,0.5),
                rgba(0,0,0,0.5)
            ),

            url('https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1974&auto=format&fit=crop');

            background-size:cover;
            background-position:center;
        }

        .login-container{

            width:400px;

            background:white;

            padding:40px;

            border-radius:20px;

            box-shadow:
            0 10px 30px rgba(0,0,0,0.3);
        }

        .logo{

            text-align:center;

            font-size:40px;

            font-weight:bold;

            color:#ff6b00;

            margin-bottom:10px;
        }

        .title{

            text-align:center;

            margin-bottom:30px;

            color:#333;
        }

        .form-group{

            margin-bottom:20px;
        }

        .form-group label{

            display:block;

            margin-bottom:8px;

            color:#555;

            font-weight:bold;
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

            box-shadow:
            0 0 5px rgba(255,107,0,0.5);
        }

        .login-btn{

            width:100%;

            padding:14px;

            border:none;

            border-radius:10px;

            background:#ff6b00;

            color:white;

            font-size:18px;

            cursor:pointer;

            transition:0.3s;
        }

        .login-btn:hover{

            background:#ff8c33;
        }

        .register-link{

            margin-top:20px;

            text-align:center;
        }

        .register-link a{

            color:#ff6b00;

            text-decoration:none;

            font-weight:bold;
        }

        .register-link a:hover{

            text-decoration:underline;
        }

    </style>

</head>

<body>

<div class="login-container">

    <div class="logo">
        7-Eleven
    </div>

    <h2 class="title">
        Welcome Back
    </h2>

    <form action="login" method="post">

        <div class="form-group">

            <label>Email</label>

            <input
                    type="email"
                    name="email"
                    placeholder="Enter your email"
                    required
            >

        </div>

        <div class="form-group">

            <label>Password</label>

            <input
                    type="password"
                    name="password"
                    placeholder="Enter your password"
                    required
            >

        </div>

        <button type="submit"
                class="login-btn">

            Login

        </button>

    </form>

    <div class="register-link">

        Don't have an account?

        <a href="register.jsp">
            Register
        </a>

    </div>

</div>

</body>

</html>