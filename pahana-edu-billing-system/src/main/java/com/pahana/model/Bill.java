package com.pahana.model;

import java.time.LocalDateTime;
import java.util.List;



public class Bill {
	  	private String billId;
	    private Customer customer;
	    private LocalDateTime date;
	    private List<BillItem> items;
	    private double totalAmount;
	    private String paymentMethod;
	    
	    public void addBill() {
	    	
	    }
	    
	    public void deleteBill() {
	    	
	    }
	    
	    public void calculateTotal() {
	        if (items != null && !items.isEmpty()) {
	            this.totalAmount = items.stream()
	                .mapToDouble(BillItem::calculateSubTotal)
	                .sum();
	        } else {
	            this.totalAmount = 0.0;
	        }
	    }
	    
	    public void applyDiscount() {
	       
	        this.totalAmount = this.totalAmount * 0.9;
	    }

	    
	    public void printBill() {
	        System.out.println("=== BILL ===");
	        System.out.println("Bill ID: " + billId);
	        System.out.println("Customer: " + (customer != null ? customer.getAccountNumber() : "N/A"));
	        System.out.println("Date: " + date);
	        System.out.println("Payment Method: " + paymentMethod);
	        System.out.println("Items:");
	        if (items != null) {
	            for (BillItem item : items) {
	                System.out.println("  - Item: " + item.getItem().getItemId() + 
	                    ", Qty: " + item.getQuantity() + 
	                    ", Price: " + item.getUnitPrice() + 
	                    ", Subtotal: " + item.calculateSubTotal());
	            }
	        }
	        System.out.println("Total Amount: " + totalAmount);
	        System.out.println("============");
	    }

		public String getBillId() {
			return billId;
		}

		public void setBillId(String billId) {
			this.billId = billId;
		}

		public Customer getCustomer() {
			return customer;
		}

		public void setCustomer(Customer customer) {
			this.customer = customer;
		}

		public LocalDateTime getDate() {
			return date;
		}

		public void setDate(LocalDateTime date) {
			this.date = date;
		}

		public List<BillItem> getItems() {
			return items;
		}

		public void setItems(List<BillItem> items) {
			this.items = items;
			calculateTotal();
		}

		public double getTotalAmount() {
			return totalAmount;
		}

		public void setTotalAmount(double totalAmount) {
			this.totalAmount = totalAmount;
		}

		public String getPaymentMethod() {
			return paymentMethod;
		}

		public void setPaymentMethod(String paymentMethod) {
			this.paymentMethod = paymentMethod;
		}
	    
		
	    
}
