package com.pahana.controller;

import com.pahana.model.Item;
import com.pahana.service.ItemService;


import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ItemController extends HttpServlet {
    private ItemService itemService;

    @Override
    public void init() {
        itemService = ItemService.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteItem(request, response);
                break;
            default:
                listItems(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        switch (action) {
            case "add":
                addItem(request, response);
                break;
            case "update":
                updateItem(request, response);
                break;
        }
    }

    private void listItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Item> items = itemService.getAllItems();
        request.setAttribute("items", items);
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/manage-items.jsp");
        dispatcher.forward(request, response);
    }

    private void addItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Item item = extractItemFromRequest(request);
        itemService.addItem(item);
        response.sendRedirect("ItemController");
    }

    private void updateItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Item item = extractItemFromRequest(request);
        item.setItemId(Integer.parseInt(request.getParameter("itemId")));
        // Don't change the itemCode when updating - keep the original
        Item existingItem = itemService.getItemById(Integer.parseInt(request.getParameter("itemId")));
        item.setItemCode(existingItem.getItemCode());
        itemService.updateItem(item);
        response.sendRedirect("ItemController");
    }

    private void deleteItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        itemService.deleteItem(itemId);
        response.sendRedirect("ItemController");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        Item item = itemService.getItemById(itemId);
        request.setAttribute("item", item);
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/item-form.jsp");
        dispatcher.forward(request, response);
    }

    private Item extractItemFromRequest(HttpServletRequest request) {
        Item item = new Item();
        item.setName(request.getParameter("name"));
        item.setDescription(request.getParameter("description"));
        item.setPrice(Double.parseDouble(request.getParameter("price")));
        item.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
        item.setCategory(request.getParameter("category"));
        return item;
    }

}
