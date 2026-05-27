package LHT.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import LHT.dao.impl.ProductDAO;
import LHT.model.Product;
import LHT.service.impl.ProductService;

@WebServlet("/products")
public class ProductController extends HttpServlet {

	 @Override
	    protected void doGet(
	            HttpServletRequest request,
	            HttpServletResponse response)
	            throws ServletException, IOException {

	        ProductService service =
	                new ProductService();

	        List<Product> products =
	                service.getAllProducts();

	        request.setAttribute(
	                "products",
	                products
	        );

	        request.getRequestDispatcher(
	                "products.jsp"
	        ).forward(request, response);
	    }
}