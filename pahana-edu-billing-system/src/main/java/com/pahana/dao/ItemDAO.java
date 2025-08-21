package com.pahana.dao;

import com.pahana.model.Item;
import com.pahana.util.DBConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    private String generateItemCode(Connection conn, String category) throws SQLException {
        String prefix;

        // assign prefix based on category
        switch (category.toLowerCase()) {
            case "books":
                prefix = "BK";
                break;
            case "stationery":
                prefix = "ST";
                break;
            case "office supplies":
                prefix = "OF";
                break;
            default:
                prefix = "C"; // fallback
        }

        String lastCode = null;
        String query = "SELECT itemCode FROM Item WHERE itemCode LIKE ? ORDER BY itemId DESC LIMIT 1";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, prefix + "%");
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                lastCode = rs.getString("itemCode");
            }
        }

        if (lastCode == null) {
            return prefix + "001";
        }

        int num = Integer.parseInt(lastCode.substring(prefix.length()));
        return String.format("%s%03d", prefix, num + 1);
    }


    public boolean addItem(Item item) {
        String query = "INSERT INTO Item (itemCode, name, description, price, stockQuantity, category) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            // generate itemCode automatically
        	String code = generateItemCode(conn, item.getCategory());
            item.setItemCode(code);

            stmt.setString(1, item.getItemCode());
            stmt.setString(2, item.getName());
            stmt.setString(3, item.getDescription());
            stmt.setDouble(4, item.getPrice());
            stmt.setInt(5, item.getStockQuantity());
            stmt.setString(6, item.getCategory());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateItem(Item item) {
        String query = "UPDATE Item SET itemCode=?, name=?, description=?, price=?, stockQuantity=?, category=? WHERE itemId=?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, item.getItemCode());
            stmt.setString(2, item.getName());
            stmt.setString(3, item.getDescription());
            stmt.setDouble(4, item.getPrice());
            stmt.setInt(5, item.getStockQuantity());
            stmt.setString(6, item.getCategory());
            stmt.setInt(7, item.getItemId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteItem(int itemId) {
        String query = "DELETE FROM Item WHERE itemId=?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, itemId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Item getItemById(int itemId) {
        String query = "SELECT * FROM Item WHERE itemId=?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, itemId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("itemId"));
                item.setItemCode(rs.getString("itemCode"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getDouble("price"));
                item.setStockQuantity(rs.getInt("stockQuantity"));
                item.setCategory(rs.getString("category"));
                return item;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Item> getAllItems() {
        List<Item> itemList = new ArrayList<>();
        String query = "SELECT * FROM Item";
        try (Connection conn = DBConnectionFactory.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("itemId"));
                item.setItemCode(rs.getString("itemCode"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getDouble("price"));
                item.setStockQuantity(rs.getInt("stockQuantity"));
                item.setCategory(rs.getString("category"));
                itemList.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return itemList;
    }
    
    public Item getItemByCode(String itemCode) {
        String query = "SELECT * FROM item WHERE itemCode = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, itemCode);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("itemId"));
                item.setItemCode(rs.getString("itemCode"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getDouble("price"));
                item.setStockQuantity(rs.getInt("stockQuantity"));
                item.setCategory(rs.getString("category"));
                return item;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
