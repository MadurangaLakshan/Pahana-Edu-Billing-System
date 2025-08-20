package com.pahana.model;

public class BillItem {
	  private Item item;
	  private int quantity;
	  private double unitPrice; 
	  
	  public double calculateSubTotal() {
		 return quantity * unitPrice;
		  
	  }
	  
	  public void getItemDetails() {
		  
	  }

	  public Item getItem() {
		  return item;
	  }

	  public void setItem(Item item) {
		  this.item = item;
	  }

	  public int getQuantity() {
		  return quantity;
	  }

	  public void setQuantity(int quantity) {
		  this.quantity = quantity;
	  }

	  public double getUnitPrice() {
		  return unitPrice;
	  }

	  public void setUnitPrice(double unitPrice) {
		  this.unitPrice = unitPrice;
	  }
	  
	  
}
