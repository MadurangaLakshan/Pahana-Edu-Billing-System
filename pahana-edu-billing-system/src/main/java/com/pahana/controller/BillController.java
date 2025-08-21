package com.pahana.controller;

import com.pahana.model.*;
import com.pahana.service.BillService;
import com.pahana.dao.ItemDAO;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BillController extends HttpServlet {
    private BillService billService;

    @Override
    public void init() {
        billService = BillService.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("preview".equals(action)) {
           
            String billIdParam = request.getParameter("billId");
            
            if (billIdParam == null || billIdParam.trim().isEmpty() || "null".equals(billIdParam)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid bill ID");
                return;
            }
            
            Bill bill = billService.getBillById(billIdParam);

            if (bill != null) {
                request.setAttribute("bill", bill);
                RequestDispatcher dispatcher = request.getRequestDispatcher("views/print-bill.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill not found");
            }
        } else {
            // Default: show all bills or redirect to billing form
            response.sendRedirect("views/billing-form.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            try {
                Bill bill = new Bill();
                
                // Don't set billId from request - let the service/DAO generate it
                // bill.setBillId(request.getParameter("billId")); // Remove this line

                // Set customer
                String customerIdParam = request.getParameter("customerId");
                if (customerIdParam == null || customerIdParam.trim().isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Customer ID is required");
                    return;
                }

                Customer customer = new Customer();
                customer.setCustomerId(Integer.parseInt(customerIdParam));
                bill.setCustomer(customer);
                
                bill.setDate(LocalDateTime.now());
                bill.setPaymentMethod(request.getParameter("paymentMethod"));

                // Populate Bill Items from request
                List<BillItem> items = new ArrayList<>();
                String[] itemCodes = request.getParameterValues("itemCode");
                String[] quantities = request.getParameterValues("quantity");
                String[] prices = request.getParameterValues("unitPrice");

                if (itemCodes != null && itemCodes.length > 0) {
                    ItemDAO itemDAO = new ItemDAO();
                    
                    for (int i = 0; i < itemCodes.length; i++) {
                        if (itemCodes[i] != null && !itemCodes[i].trim().isEmpty()) {
                            BillItem billItem = new BillItem();
                            Item item = itemDAO.getItemByCode(itemCodes[i]);
                            
                            if (item != null) {
                                billItem.setItem(item);
                                billItem.setQuantity(Integer.parseInt(quantities[i]));
                                billItem.setUnitPrice(Double.parseDouble(prices[i]));
                                items.add(billItem);
                            }
                        }
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No items provided");
                    return;
                }

                bill.setItems(items);
                
                // Add bill and get the created bill with generated ID
                Bill createdBill = billService.addBill(bill);
                
                // Forward directly to print-bill.jsp with the created bill
                request.setAttribute("bill", createdBill);
                RequestDispatcher dispatcher = request.getRequestDispatcher("views/print-bill.jsp");
                dispatcher.forward(request, response);
                
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format in request");
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating bill: " + e.getMessage());
            }
        }
    }
}