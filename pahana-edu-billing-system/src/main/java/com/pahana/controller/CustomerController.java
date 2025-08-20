package com.pahana.controller;

import com.pahana.model.Customer;
import com.pahana.service.CustomerService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

public class CustomerController extends HttpServlet {
    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
       
        customerService = CustomerService.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
        	case "new":
        		showNewForm(request, response);
            	break;
            case "view":
                viewCustomer(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteCustomer(request, response);
                break;
            default:
                listCustomers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":
                addCustomer(request, response);
                break;
            case "update":
                updateCustomer(request, response);
                break;
        }
    }

    // View all customers
    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Customer> customers = customerService.getAllCustomers();
        request.setAttribute("customers", customers);
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/manage-customers.jsp");
        dispatcher.forward(request, response);
    }

    // View specific customer
    private void viewCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        System.out.println("View customer - received id parameter: " + idParam);
        
        try {
            int id = Integer.parseInt(idParam);
            Customer customer = customerService.getCustomerById(id);
            request.setAttribute("customer", customer);
            RequestDispatcher dispatcher = request.getRequestDispatcher("views/customer-view.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            System.err.println("Invalid id parameter: " + idParam + " - must be a number (customerId)");
            response.sendRedirect(request.getContextPath() + "/CustomerController?action=list&error=invalid_id");
        }
    }

    // Show form for editing
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        System.out.println("Edit form - received id parameter: " + idParam);
        
        try {
            int id = Integer.parseInt(idParam);
            Customer existingCustomer = customerService.getCustomerById(id);
            request.setAttribute("customer", existingCustomer);
            RequestDispatcher dispatcher = request.getRequestDispatcher("views/customer-form.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            System.err.println("Invalid id parameter: " + idParam + " - must be a number (customerId)");
            // Redirect back to customer list with error
            response.sendRedirect(request.getContextPath() + "/CustomerController?action=list&error=invalid_id");
        }
    }

    // Add new customer
    private void addCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Customer customer = extractCustomerFromRequest(request);
        customerService.addCustomer(customer);
        // Redirect to customer list after successful addition
        response.sendRedirect(request.getContextPath() + "/CustomerController?action=list");
    }

    // Update existing customer
    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
    	Customer customer = extractCustomerFromRequest(request);

    	// Get customerId (hidden field in form)
    	customer.setCustomerId(Integer.parseInt(request.getParameter("customerId")));

    	// Keep the existing accountNumber (readonly field in form)
    	customer.setAccountNumber(request.getParameter("accountNumber"));

    	customerService.updateCustomer(customer);

        // Redirect to customer list after successful update
        response.sendRedirect(request.getContextPath() + "/CustomerController?action=list");
    }

    // Delete customer
    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String idParam = request.getParameter("id");
        System.out.println("Delete customer - received id parameter: " + idParam);
        
        try {
            int id = Integer.parseInt(idParam);
            customerService.deleteCustomer(id);
            response.sendRedirect(request.getContextPath() + "/CustomerController?action=list");
        } catch (NumberFormatException e) {
            System.err.println("Invalid id parameter: " + idParam + " - must be a number (customerId)");
            response.sendRedirect(request.getContextPath() + "/CustomerController?action=list&error=invalid_id");
        }
    }
    // Helper method to extract customer data from form
    private Customer extractCustomerFromRequest(HttpServletRequest request) {
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");
        String email = request.getParameter("email");

        // Use current date instead of getting from form
        LocalDate regDate = LocalDate.now();

        Customer customer = new Customer();
        customer.setName(name);
        customer.setAddress(address);
        customer.setTelephone(telephone);
        customer.setEmail(email);
        customer.setRegistrationDate(regDate);

        return customer;
    }
    
//    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String nextAccountNumber = customerService.getNextAccountNumber();
//        request.setAttribute("nextAccountNumber", nextAccountNumber);
//        RequestDispatcher dispatcher = request.getRequestDispatcher("views/customer-form.jsp");
//        dispatcher.forward(request, response);
//    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== DEBUG: showNewForm called ===");
        
        String nextAccountNumber = customerService.getNextAccountNumber();
        System.out.println("Generated nextAccountNumber: " + nextAccountNumber);
        
        request.setAttribute("nextAccountNumber", nextAccountNumber);
        request.setAttribute("customer", null);
        
        // Verify attributes are set
        System.out.println("nextAccountNumber attribute: " + request.getAttribute("nextAccountNumber"));
        System.out.println("customer attribute: " + request.getAttribute("customer"));
        System.out.println("=== END DEBUG ===");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/customer-form.jsp");
        dispatcher.forward(request, response);
    }

}