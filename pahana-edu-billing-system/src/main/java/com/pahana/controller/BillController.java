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
            // existing preview logic
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

        } else if ("list".equals(action)) {
       
            List<Bill> bills = billService.getAllBills();
            request.setAttribute("bills", bills);
            

            RequestDispatcher dispatcher = request.getRequestDispatcher("views/manage-bills.jsp");
            dispatcher.forward(request, response);

        } else {
           
            RequestDispatcher dispatcher = request.getRequestDispatcher("views/manage-billl.jsp");
        }
    }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("preview".equals(action)) {
            try {
                Bill bill = new Bill();

                // Customer (try to fetch full customer for preview)
                String customerIdParam = request.getParameter("customerId");
                if (customerIdParam == null || customerIdParam.trim().isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Customer ID is required for preview");
                    return;
                }
                int customerId = Integer.parseInt(customerIdParam);
                com.pahana.dao.CustomerDAO customerDAO = new com.pahana.dao.CustomerDAO();
                Customer customer = customerDAO.getCustomerById(customerId);
                if (customer == null) {
                    // if you don't have a full customer in DB, create a minimal one for preview
                    customer = new Customer();
                    customer.setCustomerId(customerId);
                    customer.setName(request.getParameter("customerName")); // optional field from form
                }
                bill.setCustomer(customer);

                // Date (use provided or now)
                String dateParam = request.getParameter("date"); // optional if your form supplies it
                if (dateParam != null && !dateParam.trim().isEmpty()) {
                    // parse if you pass a formatted date; otherwise just set now
                    // e.g. LocalDateTime.parse(...) if format matches
                    bill.setDate(LocalDateTime.now());
                } else {
                    bill.setDate(LocalDateTime.now());
                }

                bill.setPaymentMethod(request.getParameter("paymentMethod"));

                // Items (same parsing as create)
                List<BillItem> items = new ArrayList<>();
                String[] itemCodes = request.getParameterValues("itemCode");
                String[] quantities = request.getParameterValues("quantity");
                String[] prices = request.getParameterValues("unitPrice");

                if (itemCodes != null && itemCodes.length > 0) {
                    com.pahana.dao.ItemDAO itemDAO = new ItemDAO();
                    for (int i = 0; i < itemCodes.length; i++) {
                        if (itemCodes[i] != null && !itemCodes[i].trim().isEmpty()) {
                            Item item = itemDAO.getItemByCode(itemCodes[i]);
                            BillItem bi = new BillItem();
                            if (item != null) bi.setItem(item);
                            else {
                                // fallback minimal item for preview:
                                item = new Item();
                                item.setItemCode(itemCodes[i]);
                                item.setName(request.getParameter("itemName[" + i + "]")); // optional
                                bi.setItem(item);
                            }

                            // safe parsing
                            int qty = 0;
                            double unitPrice = 0;
                            try { qty = Integer.parseInt(quantities[i]); } catch (Exception ignored) {}
                            try { unitPrice = Double.parseDouble(prices[i]); } catch (Exception ignored) {}

                            bi.setQuantity(qty);
                            bi.setUnitPrice(unitPrice);
                            items.add(bi);
                        }
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No items provided for preview");
                    return;
                }

                bill.setItems(items);

                // compute total for preview (optional)
                double total = items.stream().mapToDouble(it -> it.getUnitPrice() * it.getQuantity()).sum();
                bill.setTotalAmount(total);

                // mark preview so JSP can optionally hide "save" buttons
                request.setAttribute("preview", true);
                request.setAttribute("bill", bill);

                RequestDispatcher dispatcher = request.getRequestDispatcher("views/print-bill.jsp");
                dispatcher.forward(request, response);

            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format in preview request");
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error building preview: " + e.getMessage());
            }

        } else if ("create".equals(action)) {
            // your existing create handling (unchanged) — call billService.addBill(...) etc.
            try {
                Bill bill = new Bill();
                // ... (current create code you already have)
                // after creating:
                Bill createdBill = billService.addBill(bill);
                request.setAttribute("bill", createdBill);
                RequestDispatcher dispatcher = request.getRequestDispatcher("views/print-bill.jsp");
                dispatcher.forward(request, response);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format in request");
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating bill: " + e.getMessage());
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    
}