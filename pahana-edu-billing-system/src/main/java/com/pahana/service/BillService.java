package com.pahana.service;

import com.pahana.dao.BillDAO;
import com.pahana.model.Bill;

import java.util.List;

public class BillService {

    private static BillService instance;
    private BillDAO billDAO;

    private BillService() {
        this.billDAO = new BillDAO();
    }

    public static BillService getInstance() {
        if (instance == null) {
            synchronized (BillService.class) {
                if (instance == null) {
                    instance = new BillService();
                }
            }
        }
        return instance;
    }

    public Bill addBill(Bill bill) {
    	bill.calculateTotal();
        return billDAO.addBill(bill);
    }

    public boolean deleteBill(String billId) {
        return billDAO.deleteBill(billId);
    }

    public Bill getBillById(String billId) {
        return billDAO.getBillById(billId);
    }

    public List<Bill> getAllBills() {
        return billDAO.getAllBills();
    }
}
