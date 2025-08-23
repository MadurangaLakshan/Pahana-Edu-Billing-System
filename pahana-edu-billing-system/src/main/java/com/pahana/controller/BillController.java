package com.pahana.controller;

import com.pahana.model.*;
import com.pahana.service.BillService;
import com.pahana.dao.BillDAO;
import com.pahana.dao.ReportDAO;

import com.pahana.dao.ReportDAO.TopProduct;

import com.pahana.dao.ReportDAO.DailyRevenue;
import com.pahana.dao.ItemDAO;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BillController extends HttpServlet {
    private BillService billService;
    private BillDAO billDAO;
    private ReportDAO reportDAO;

    @Override
    public void init() {
        billService = BillService.getInstance();
        billDAO = new BillDAO();
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

        } else if ("list".equals(action)) {
            List<Bill> bills = billService.getAllBills();
            request.setAttribute("bills", bills);

            RequestDispatcher dispatcher = request.getRequestDispatcher("views/manage-bills.jsp");
            dispatcher.forward(request, response);

        } else if ("analytics".equals(action) || "report".equals(action)) {
            // Handle analytics report request
            try {
                // Get all analytics data
                double totalRevenue = reportDAO.getTotalRevenue();
                double todayRevenue = reportDAO.getTodayRevenue();
                double weekRevenue = reportDAO.getWeekRevenue();
                double monthRevenue = reportDAO.getMonthRevenue();
                
                // Get top 5 products
                List<TopProduct> topProducts = reportDAO.getTopProducts(5);
                
                // Get daily revenue for chart (last 30 days)
                List<DailyRevenue> dailyRevenue = reportDAO.getDailyRevenue(30);
                
                // Set attributes for JSP
                request.setAttribute("totalRevenue", totalRevenue);
                request.setAttribute("todayRevenue", todayRevenue);
                request.setAttribute("weekRevenue", weekRevenue);
                request.setAttribute("monthRevenue", monthRevenue);
                request.setAttribute("topProducts", topProducts);
                request.setAttribute("dailyRevenue", dailyRevenue);
                
                // Forward to analytics report JSP
                RequestDispatcher dispatcher = request.getRequestDispatcher("views/analytics-report.jsp");
                dispatcher.forward(request, response);
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Error generating analytics report: " + e.getMessage());
            }

        } else {
            RequestDispatcher dispatcher = request.getRequestDispatcher("views/manage-bills.jsp");
            dispatcher.forward(request, response);
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
                    customer.setName(request.getParameter("customerName")); 
                }
                bill.setCustomer(customer);

                // Date (use provided or now)
                String dateParam = request.getParameter("date"); 
                if (dateParam != null && !dateParam.trim().isEmpty()) {
                   
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
                                item.setName(request.getParameter("itemName[" + i + "]"));
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
            
            try {
                Bill bill = new Bill();
                
                // Parse customer
                String customerIdParam = request.getParameter("customerId");
                if (customerIdParam == null || customerIdParam.trim().isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Customer ID is required");
                    return;
                }
                int customerId = Integer.parseInt(customerIdParam);
                Customer customer = new Customer();
                customer.setCustomerId(customerId);
                bill.setCustomer(customer);

                // Set other bill properties
                bill.setDate(LocalDateTime.now());
                bill.setPaymentMethod(request.getParameter("paymentMethod"));

                // Parse items
                List<BillItem> items = new ArrayList<>();
                String[] itemCodes = request.getParameterValues("itemCode");
                String[] quantities = request.getParameterValues("quantity");
                String[] prices = request.getParameterValues("unitPrice");

                if (itemCodes != null && itemCodes.length > 0) {
                    com.pahana.dao.ItemDAO itemDAO = new ItemDAO();
                    double total = 0;
                    
                    for (int i = 0; i < itemCodes.length; i++) {
                        if (itemCodes[i] != null && !itemCodes[i].trim().isEmpty()) {
                            Item item = itemDAO.getItemByCode(itemCodes[i]);
                            if (item != null) {
                                BillItem bi = new BillItem();
                                bi.setItem(item);
                                
                                int qty = Integer.parseInt(quantities[i]);
                                double unitPrice = Double.parseDouble(prices[i]);
                                
                                bi.setQuantity(qty);
                                bi.setUnitPrice(unitPrice);
                                items.add(bi);
                                
                                total += qty * unitPrice;
                            }
                        }
                    }
                    
                    bill.setItems(items);
                    bill.setTotalAmount(total);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No items provided");
                    return;
                }

                Bill createdBill = billService.addBill(bill);
                if (createdBill != null) {
                    request.setAttribute("bill", createdBill);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("views/print-bill.jsp");
                    dispatcher.forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create bill");
                }
                
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