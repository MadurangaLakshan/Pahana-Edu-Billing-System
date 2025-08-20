package com.pahana.model;

import java.time.LocalDate;

public class Customer {
	 
	    private int customerId;       
	    private String accountNumber; 
	    private String name;
	    private String address;
	    private String telephone;
	    private String email;
	    private LocalDate registrationDate;
	    
	    public void addCustomer() {
	    	
	    }
	    
	    public void updateCustomer() {
	    	
	    }

	    public void deleteCustomer() {
	
	    }
	    
	    public void viewAccount() {
	    	
	    }
		
		public int getCustomerId() {
			return customerId;
		}

		public void setCustomerId(int customerId) {
			this.customerId = customerId;
		}

		public String getAccountNumber() {
		    return accountNumber;
		}

		public void setAccountNumber(String accountNumber) {
		    this.accountNumber = accountNumber;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getAddress() {
			return address;
		}

		public void setAddress(String address) {
			this.address = address;
		}

		public String getTelephone() {
			return telephone;
		}

		public void setTelephone(String telephone) {
			this.telephone = telephone;
		}

		public String getEmail() {
			return email;
		}

		public void setEmail(String email) {
			this.email = email;
		}

		public LocalDate getRegistrationDate() {
			return registrationDate;
		}

		public void setRegistrationDate(LocalDate registrationDate) {
			this.registrationDate = registrationDate;
		}
	    
	    
}
