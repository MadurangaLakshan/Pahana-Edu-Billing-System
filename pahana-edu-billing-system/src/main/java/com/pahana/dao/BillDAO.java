package com.pahana.dao;

import com.pahana.model.*;
import com.pahana.util.DBConnectionFactory;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {
    
    public Bill addBill(Bill bill) {
        String billQuery = "INSERT INTO bill (customerId, date, totalAmount, paymentMethod) VALUES (?, ?, ?, ?)";
        String billItemQuery = "INSERT INTO bill_item (billId, itemId, quantity, unitPrice) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnectionFactory.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement billStmt = conn.prepareStatement(billQuery, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement itemStmt = conn.prepareStatement(billItemQuery)) {

                billStmt.setInt(1, bill.getCustomer().getCustomerId());
                billStmt.setTimestamp(2, Timestamp.valueOf(bill.getDate()));
                billStmt.setDouble(3, bill.getTotalAmount());
                billStmt.setString(4, bill.getPaymentMethod());
                billStmt.executeUpdate();

                ResultSet rs = billStmt.getGeneratedKeys();
                int generatedBillId = 0;
                if (rs.next()) {
                    generatedBillId = rs.getInt(1);
                    bill.setBillId(String.valueOf(generatedBillId));
                }

                if (bill.getItems() != null && !bill.getItems().isEmpty()) {
                    for (BillItem item : bill.getItems()) {
                        itemStmt.setInt(1, generatedBillId);
                        itemStmt.setInt(2, item.getItem().getItemId());
                        itemStmt.setInt(3, item.getQuantity());
                        itemStmt.setDouble(4, item.getUnitPrice());
                        itemStmt.addBatch();
                    }
                    itemStmt.executeBatch();
                }

                conn.commit();
                
                CustomerDAO customerDAO = new CustomerDAO();
                Customer completeCustomer = customerDAO.getCustomerById(bill.getCustomer().getCustomerId());
                if (completeCustomer != null) {
                    bill.setCustomer(completeCustomer);
                }
                
                return bill;

            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return null; 
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return null; 
        }
    }

    public boolean deleteBill(String billId) {
        String deleteItems = "DELETE FROM bill_item WHERE billId = ?";
        String deleteBill = "DELETE FROM bill WHERE billId = ?";

        try (Connection conn = DBConnectionFactory.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement stmt1 = conn.prepareStatement(deleteItems);
                 PreparedStatement stmt2 = conn.prepareStatement(deleteBill)) {

                int billIdInt = Integer.parseInt(billId);
                stmt1.setInt(1, billIdInt);
                stmt1.executeUpdate();

                stmt2.setInt(1, billIdInt);
                stmt2.executeUpdate();

                conn.commit();
                return true;

            } catch (SQLException | NumberFormatException e) {
                conn.rollback();
                e.printStackTrace();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Bill getBillById(String billId) {
        String billQuery = """
            SELECT b.*, c.name, c.accountNumber, c.email, c.telephone, c.address 
            FROM bill b 
            LEFT JOIN customer c ON b.customerId = c.customerId 
            WHERE b.billId = ?
            """;
       
        String itemQuery = """
            SELECT bi.*, i.itemCode, i.name, i.description, i.price 
            FROM bill_item bi 
            INNER JOIN item i ON bi.itemId = i.itemId 
            WHERE bi.billId = ?
            """;

        try (Connection conn = DBConnectionFactory.getConnection()) {
            Bill bill = null;
            
            try (PreparedStatement billStmt = conn.prepareStatement(billQuery)) {
                billStmt.setInt(1, Integer.parseInt(billId)); 
                ResultSet billRs = billStmt.executeQuery();

                if (billRs.next()) {
                    bill = new Bill();
                    bill.setBillId(billId);
                    bill.setDate(billRs.getTimestamp("date").toLocalDateTime());
                    bill.setPaymentMethod(billRs.getString("paymentMethod"));
                    bill.setTotalAmount(billRs.getDouble("totalAmount"));

                    Customer customer = new Customer();
                    customer.setCustomerId(billRs.getInt("customerId")); 
                    customer.setAccountNumber(billRs.getString("accountNumber")); 
                    customer.setName(billRs.getString("name")); 
                    bill.setCustomer(customer);
                }
            }
            
            if (bill != null) {
                try (PreparedStatement itemStmt = conn.prepareStatement(itemQuery)) {
                    itemStmt.setInt(1, Integer.parseInt(billId)); 
                    ResultSet itemRs = itemStmt.executeQuery();
                    List<BillItem> items = new ArrayList<>();

                    while (itemRs.next()) {
                        BillItem billItem = new BillItem();
                        Item item = new Item();
                        
                        item.setItemId(itemRs.getInt("itemId"));
                        item.setItemCode(itemRs.getString("itemCode")); 
                        item.setName(itemRs.getString("name")); 
                      
                        billItem.setItem(item);
                        billItem.setQuantity(itemRs.getInt("quantity"));
                        billItem.setUnitPrice(itemRs.getDouble("unitPrice"));
                        items.add(billItem);
                    }
                    bill.setItems(items);
                }
            }
            
            return bill;

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Bill> getAllBills() {
        List<Bill> bills = new ArrayList<>();
        String query = """
                SELECT b.*, c.name, c.accountNumber, c.email, c.telephone, c.address
                FROM bill b
                INNER JOIN customer c ON b.customerId = c.customerId
                ORDER BY b.date DESC
            """;

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(String.valueOf(rs.getInt("billId")));
                bill.setDate(rs.getTimestamp("date").toLocalDateTime());
                bill.setTotalAmount(rs.getDouble("totalAmount"));
                bill.setPaymentMethod(rs.getString("paymentMethod"));

                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customerId"));
                customer.setName(rs.getString("name"));
                customer.setAccountNumber(rs.getString("accountNumber"));
                customer.setEmail(rs.getString("email"));
                customer.setTelephone(rs.getString("telephone"));
                customer.setAddress(rs.getString("address"));
                bill.setCustomer(customer);

                bills.add(bill);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bills;
    }

 
    public List<Bill> getBillsByCustomerId(int customerId) {
        List<Bill> bills = new ArrayList<>();
        String query = """
                SELECT b.*, c.name, c.accountNumber, c.email, c.telephone, c.address
                FROM bill b
                INNER JOIN customer c ON b.customerId = c.customerId
                WHERE b.customerId = ?
                ORDER BY b.date DESC
            """;

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(String.valueOf(rs.getInt("billId")));
                bill.setDate(rs.getTimestamp("date").toLocalDateTime());
                bill.setTotalAmount(rs.getDouble("totalAmount"));
                bill.setPaymentMethod(rs.getString("paymentMethod"));

                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customerId"));
                customer.setName(rs.getString("name"));
                customer.setAccountNumber(rs.getString("accountNumber"));
                customer.setEmail(rs.getString("email"));
                customer.setTelephone(rs.getString("telephone"));
                customer.setAddress(rs.getString("address"));
                bill.setCustomer(customer);

                bills.add(bill);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bills;
    }

 
    public boolean updateBill(Bill bill) {
        String updateBillQuery = "UPDATE bill SET customerId = ?, date = ?, totalAmount = ?, paymentMethod = ? WHERE billId = ?";
        
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(updateBillQuery)) {
            
            stmt.setInt(1, bill.getCustomer().getCustomerId());
            stmt.setTimestamp(2, Timestamp.valueOf(bill.getDate()));
            stmt.setDouble(3, bill.getTotalAmount());
            stmt.setString(4, bill.getPaymentMethod());
            stmt.setInt(5, Integer.parseInt(bill.getBillId()));
            
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            return false;
        }
    }

  
    public int getTotalBillCount() {
        String query = "SELECT COUNT(*) as count FROM bill";
        
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}