package com.pahana.dao;

import com.pahana.model.Customer;
import com.pahana.util.DBConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    // Add Customer
	public int addCustomer(Customer customer) {
	    String query = "INSERT INTO customer (accountNumber, name, address, telephone, email, registrationDate) VALUES (?, ?, ?, ?, ?, ?)";

	    try (Connection connection = DBConnectionFactory.getConnection();
	         PreparedStatement statement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

	        // First insert a temporary placeholder for accountNumber (will update after insert)
	        statement.setString(1, "TEMP");
	        statement.setString(2, customer.getName());
	        statement.setString(3, customer.getAddress());
	        statement.setString(4, customer.getTelephone());
	        statement.setString(5, customer.getEmail());
	        statement.setDate(6, Date.valueOf(customer.getRegistrationDate()));

	        int result = statement.executeUpdate();

	        if (result > 0) {
	            ResultSet generatedKeys = statement.getGeneratedKeys();
	            if (generatedKeys.next()) {
	                int newId = generatedKeys.getInt(1);
	                String accountNumber = String.format("C%04d", newId); // C0001, C0002, etc.

	                // Update accountNumber
	                String updateQuery = "UPDATE customer SET accountNumber = ? WHERE customerId = ?";
	                try (PreparedStatement updateStmt = connection.prepareStatement(updateQuery)) {
	                    updateStmt.setString(1, accountNumber);
	                    updateStmt.setInt(2, newId);
	                    updateStmt.executeUpdate();
	                }

	                return newId;
	            }
	        }
	        return -1;

	    } catch (SQLException e) {
	        System.err.println("Error adding customer: " + e.getMessage());
	        e.printStackTrace();
	        return -1;
	    }
	}



	public String getNextAccountNumber() {
	    String query = "SELECT accountNumber FROM customer WHERE accountNumber LIKE 'C%' ORDER BY accountNumber DESC LIMIT 1";
	    try (Connection connection = DBConnectionFactory.getConnection();
	         Statement statement = connection.createStatement();
	         ResultSet resultSet = statement.executeQuery(query)) {

	        int nextId = 1;
	        if (resultSet.next()) {
	            String lastAccountNumber = resultSet.getString(1);
	            // Extract the number part from "C0001" format
	            if (lastAccountNumber != null && lastAccountNumber.startsWith("C")) {
	                String numberPart = lastAccountNumber.substring(1); // Remove "C"
	                try {
	                    int lastNumber = Integer.parseInt(numberPart);
	                    nextId = lastNumber + 1;
	                } catch (NumberFormatException e) {
	                    System.err.println("Error parsing account number: " + lastAccountNumber);
	                    nextId = 1; // fallback
	                }
	            }
	        }
	        return String.format("C%04d", nextId); // e.g., C0001, C0002

	    } catch (SQLException e) {
	        System.err.println("Error generating next account number: " + e.getMessage());
	        e.printStackTrace();
	        return "C0001"; // fallback
	    }
	}
	


    // Get all customers
	// Get all customers
	public List<Customer> getAllCustomers() {
	    List<Customer> customers = new ArrayList<>();
	    String query = "SELECT * FROM customer ORDER BY accountNumber";

	    try (Connection connection = DBConnectionFactory.getConnection();
	         Statement statement = connection.createStatement();
	         ResultSet resultSet = statement.executeQuery(query)) {

	        while (resultSet.next()) {
	            Customer customer = new Customer();
	            customer.setCustomerId(resultSet.getInt("customerId"));   // new PK
	            customer.setAccountNumber(resultSet.getString("accountNumber")); // now String
	            customer.setName(resultSet.getString("name"));
	            customer.setAddress(resultSet.getString("address"));
	            customer.setTelephone(resultSet.getString("telephone"));
	            customer.setEmail(resultSet.getString("email"));
	            customer.setRegistrationDate(resultSet.getDate("registrationDate").toLocalDate());

	            customers.add(customer);
	        }

	    } catch (SQLException e) {
	        System.err.println("Error getting all customers: " + e.getMessage());
	        e.printStackTrace();
	    }

	    return customers;
	}


    // Get customer by account number
	// Get customer by ID (customerId, the primary key)
	public Customer getCustomerById(int customerId) {
	    String query = "SELECT * FROM customer WHERE customerId = ?";
	    Customer customer = null;

	    try (Connection connection = DBConnectionFactory.getConnection();
	         PreparedStatement statement = connection.prepareStatement(query)) {

	        statement.setInt(1, customerId);
	        ResultSet resultSet = statement.executeQuery();

	        if (resultSet.next()) {
	            customer = new Customer();
	            customer.setCustomerId(resultSet.getInt("customerId"));
	            customer.setAccountNumber(resultSet.getString("accountNumber"));
	            customer.setName(resultSet.getString("name"));
	            customer.setAddress(resultSet.getString("address"));
	            customer.setTelephone(resultSet.getString("telephone"));
	            customer.setEmail(resultSet.getString("email"));
	            customer.setRegistrationDate(resultSet.getDate("registrationDate").toLocalDate());
	        }

	    } catch (SQLException e) {
	        System.err.println("Error getting customer by ID: " + e.getMessage());
	        e.printStackTrace();
	    }

	    return customer;
	}


    // Update customer
	// Update customer (by customerId, keep accountNumber unchanged)
	public boolean updateCustomer(Customer customer) {
	    String query = "UPDATE customer SET name = ?, address = ?, telephone = ?, email = ?, registrationDate = ? WHERE customerId = ?";

	    try (Connection connection = DBConnectionFactory.getConnection();
	         PreparedStatement statement = connection.prepareStatement(query)) {

	        statement.setString(1, customer.getName());
	        statement.setString(2, customer.getAddress());
	        statement.setString(3, customer.getTelephone());
	        statement.setString(4, customer.getEmail());
	        statement.setDate(5, Date.valueOf(customer.getRegistrationDate()));
	        statement.setInt(6, customer.getCustomerId());

	        return statement.executeUpdate() > 0;

	    } catch (SQLException e) {
	        System.err.println("Error updating customer: " + e.getMessage());
	        e.printStackTrace();
	        return false;
	    }
	}


 
    
    public boolean deleteCustomer(int customerId) {
        String query = "DELETE FROM customer WHERE customerId = ?";

        try (Connection connection = DBConnectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, customerId);
            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting customer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

}