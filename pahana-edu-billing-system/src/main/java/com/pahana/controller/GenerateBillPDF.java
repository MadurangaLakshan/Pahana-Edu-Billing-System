package com.pahana.controller;

import com.pahana.model.Bill;
import com.pahana.model.BillItem;
import com.pahana.service.BillService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;
import java.time.format.DateTimeFormatter;


import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

public class GenerateBillPDF extends HttpServlet {
    private BillService billService;

    @Override
    public void init() {
        billService = BillService.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String billId = request.getParameter("billId");
        
        if (billId == null || billId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Bill ID is required");
            return;
        }

        Bill bill = billService.getBillById(billId);
        
        if (bill == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill not found");
            return;
        }

        // Set response headers for PDF download
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"bill_" + billId + ".pdf\"");

        try {
            generatePDF(bill, response.getOutputStream());
        } catch (DocumentException e) {
            throw new ServletException("Error generating PDF", e);
        }
    }

    private void generatePDF(Bill bill, OutputStream outputStream) throws DocumentException, IOException {
        Document document = new Document(PageSize.A4);
        PdfWriter.getInstance(document, outputStream);
        
        document.open();

    
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD, BaseColor.BLACK);
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.BLACK);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL, BaseColor.BLACK);
        Font boldFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.BLACK);

        // Title
        Paragraph title = new Paragraph("INVOICE", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        // Bill ID
        Paragraph billIdPara = new Paragraph("Bill ID: " + bill.getBillId(), headerFont);
        billIdPara.setAlignment(Element.ALIGN_CENTER);
        billIdPara.setSpacingAfter(30);
        document.add(billIdPara);

        // Bill Information Table
        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);
        infoTable.setSpacingAfter(20);

        // Left column - Bill Details
        PdfPCell leftCell = new PdfPCell();
        leftCell.setBorder(Rectangle.BOX);
        leftCell.setPadding(10);
        leftCell.addElement(new Paragraph("Bill Details", headerFont));
        leftCell.addElement(new Paragraph("Date: " + bill.getDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")), normalFont));
        leftCell.addElement(new Paragraph("Payment Method: " + (bill.getPaymentMethod() != null ? bill.getPaymentMethod() : "N/A"), normalFont));

        // Right column - Customer Information
        PdfPCell rightCell = new PdfPCell();
        rightCell.setBorder(Rectangle.BOX);
        rightCell.setPadding(10);
        rightCell.addElement(new Paragraph("Customer Information", headerFont));
        if (bill.getCustomer() != null) {
            rightCell.addElement(new Paragraph("Customer Name: " + bill.getCustomer().getName(), normalFont));
            rightCell.addElement(new Paragraph("Account Number: " + bill.getCustomer().getAccountNumber(), normalFont));

        } else {
            rightCell.addElement(new Paragraph("No customer information available", normalFont));
        }

        infoTable.addCell(leftCell);
        infoTable.addCell(rightCell);
        document.add(infoTable);

        // Items Table
        PdfPTable itemsTable = new PdfPTable(5);
        itemsTable.setWidthPercentage(100);
        itemsTable.setWidths(new float[]{2, 3, 1, 2, 2});
        itemsTable.setSpacingAfter(20);

        // Table headers
        String[] headers = {"Item Code", "Item Name", "Qty", "Unit Price", "Subtotal"};
        for (String header : headers) {
            PdfPCell headerCell = new PdfPCell(new Phrase(header, boldFont));
            headerCell.setBackgroundColor(BaseColor.LIGHT_GRAY);
            headerCell.setPadding(8);
            headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            itemsTable.addCell(headerCell);
        }

        // Table data
        if (bill.getItems() != null && !bill.getItems().isEmpty()) {
            for (BillItem item : bill.getItems()) {
                
            	String itemCode = item.getItem() != null ? String.valueOf(item.getItem().getItemCode()) : "N/A";
                itemsTable.addCell(itemCode);

            
                String itemName = item.getItem() != null ? item.getItem().getName() : "N/A";
                itemsTable.addCell(itemName);

              
                itemsTable.addCell(String.valueOf(item.getQuantity()));

            
                itemsTable.addCell("$" + String.format("%.2f", item.getUnitPrice()));

         
                itemsTable.addCell("$" + String.format("%.2f", item.calculateSubTotal()));
            }
        } else {
            PdfPCell noItemsCell = new PdfPCell();
            noItemsCell.setPhrase(new Phrase("No items found"));
            noItemsCell.setColspan(5);
            noItemsCell.setPadding(8);
            noItemsCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            itemsTable.addCell(noItemsCell);
        }

        // Total row
        PdfPCell totalLabelCell = new PdfPCell();
        totalLabelCell.setPhrase(new Phrase("Total Amount:"));
        totalLabelCell.setColspan(4);
        totalLabelCell.setPadding(8);
        totalLabelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totalLabelCell.setBackgroundColor(new BaseColor(232, 244, 253));
        itemsTable.addCell(totalLabelCell);

        PdfPCell totalAmountCell = new PdfPCell();
        totalAmountCell.setPhrase(new Phrase("$" + String.format("%.2f", bill.getTotalAmount())));
        totalAmountCell.setPadding(8);
        totalAmountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totalAmountCell.setBackgroundColor(new BaseColor(232, 244, 253));
        itemsTable.addCell(totalAmountCell);

        document.add(itemsTable);

        // Footer
        Paragraph footer = new Paragraph("Thank you for your business!", normalFont);
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(30);
        document.add(footer);

        Paragraph generated = new Paragraph("Generated on: " + 
            java.time.LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")), 
            new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC, BaseColor.GRAY));
        generated.setAlignment(Element.ALIGN_CENTER);
        document.add(generated);

        document.close();
    }
}