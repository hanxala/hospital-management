package com.hospital.dao;

import com.hospital.model.Bill;
import com.hospital.model.BillItem;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface BillingDao {
    Long saveBill(Bill bill);
    void saveBillItems(List<BillItem> items);
    int updatePayment(Long billId, BigDecimal paidAmount, BigDecimal balanceAmount, String paymentStatus, String paymentMode, String remarks);
    Optional<Bill> findBillById(Long id);
    Optional<Bill> findBillByNumber(String billNumber);
    List<Bill> findAllBills();
    List<Bill> findBillsByPatientId(Long patientId);
    List<BillItem> findItemsByBillId(Long billId);
    int countBills();
    int countUnpaidBills();
    BigDecimal sumTotalRevenue();
    BigDecimal sumPendingBalance();
    String generateNextBillNumber();
}
