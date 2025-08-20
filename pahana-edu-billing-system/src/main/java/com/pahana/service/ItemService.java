package com.pahana.service;

import com.pahana.dao.ItemDAO;
import com.pahana.model.Item;

import java.util.List;

public class ItemService {

    private static ItemService instance;
    private final ItemDAO itemDAO;

    private ItemService() {
        this.itemDAO = new ItemDAO();
    }

    public static ItemService getInstance() {
        if (instance == null) {
            synchronized (ItemService.class) {
                if (instance == null) {
                    instance = new ItemService();
                }
            }
        }
        return instance;
    }

    public boolean addItem(Item item) {
        return itemDAO.addItem(item);
    }

    public boolean updateItem(Item item) {
        return itemDAO.updateItem(item);
    }

    public boolean deleteItem(int itemId) {   // ✅ use int
        return itemDAO.deleteItem(itemId);
    }

    public Item getItemById(int itemId) {     // ✅ use int
        return itemDAO.getItemById(itemId);
    }

    public List<Item> getAllItems() {
        return itemDAO.getAllItems();
    }
}
