package com.pahana.service;

import com.pahana.dao.CustomerDAO;
import com.pahana.model.Customer;

import java.util.List;

public class CustomerService {

    private static CustomerService instance;
    private CustomerDAO customerDAO;

    private CustomerService() {
        this.customerDAO = new CustomerDAO();
    }

    public static CustomerService getInstance() {
        if (instance == null) {
            synchronized (CustomerService.class) {
                if (instance == null) {
                    instance = new CustomerService();
                }
            }
        }
        return instance;
    }

    public int addCustomer(Customer customer) {
        return customerDAO.addCustomer(customer);
    }

    public List<Customer> getAllCustomers() {
        return customerDAO.getAllCustomers();
    }

    public Customer getCustomerById(int accountNumber) {
        return customerDAO.getCustomerById(accountNumber);
    }

    public boolean updateCustomer(Customer customer) {
        return customerDAO.updateCustomer(customer);
    }

    public boolean deleteCustomer(int accountNumber) {
        return customerDAO.deleteCustomer(accountNumber);
    }
    
    public String getNextAccountNumber() {
        return customerDAO.getNextAccountNumber();
    }

}
