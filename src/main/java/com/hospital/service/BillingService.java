package com.hospital.service;

import com.hospital.model.Bill;
import com.hospital.model.DashboardStats;

import java.math.BigDecimal;
import java.util.List;

public interface BillingService {
    Bill prepareDraftBill(Long patientId);
    Bill generateBill(Bill bill);
    boolean processPayment(Long billId, BigDecimal paymentAmount, String paymentMode, String remarks);
    Bill getBillById(Long id);
    Bill getBillByNumber(String billNumber);
    List<Bill> getAllBills();
    List<Bill> getBillsByPatientId(Long patientId);
    DashboardStats getDashboardStatistics();
}
