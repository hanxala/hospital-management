package com.hospital.service;

import com.hospital.dao.*;
import com.hospital.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@Service
public class BillingServiceImpl implements BillingService {

    private final BillingDao billingDao;
    private final PatientDao patientDao;
    private final ConsultationDao consultationDao;
    private final LabDao labDao;
    private final DoctorDao doctorDao;
    private final AuditLogDao auditLogDao;
    private final PerformanceLogDao performanceLogDao;

    @Autowired
    public BillingServiceImpl(BillingDao billingDao, PatientDao patientDao,
                              ConsultationDao consultationDao, LabDao labDao,
                              DoctorDao doctorDao, AuditLogDao auditLogDao,
                              PerformanceLogDao performanceLogDao) {
        this.billingDao = billingDao;
        this.patientDao = patientDao;
        this.consultationDao = consultationDao;
        this.labDao = labDao;
        this.doctorDao = doctorDao;
        this.auditLogDao = auditLogDao;
        this.performanceLogDao = performanceLogDao;
    }

    @Override
    public Bill prepareDraftBill(Long patientId) {
        Patient patient = patientDao.findById(patientId)
                .orElseThrow(() -> new IllegalArgumentException("Patient not found with ID: " + patientId));

        Bill draft = new Bill();
        draft.setPatientId(patient.getId());
        draft.setPatientName(patient.getFullName());
        draft.setPatientUhid(patient.getPatientUhid());
        draft.setPatientPhone(patient.getPhone());
        draft.setPatientEmail(patient.getEmail());
        draft.setPatientAddress(patient.getAddress());
        draft.setBillNumber(billingDao.generateNextBillNumber());

        List<BillItem> items = new ArrayList<>();
        BigDecimal totalConsultation = BigDecimal.ZERO;
        BigDecimal totalLab = BigDecimal.ZERO;

        // Unbilled consultations
        List<Consultation> consultations = consultationDao.findUnbilledByPatientId(patientId);
        for (Consultation c : consultations) {
            BigDecimal fee = c.getConsultationFee() != null ? c.getConsultationFee() : BigDecimal.ZERO;
            totalConsultation = totalConsultation.add(fee);
            items.add(new BillItem("CONSULTATION",
                    "Doctor Consultation - " + (c.getDoctorName() != null ? c.getDoctorName() : "Doctor") +
                            " (" + (c.getDoctorSpecialization() != null ? c.getDoctorSpecialization() : "") + ")",
                    fee, 1, fee));
        }

        // Unbilled lab orders
        List<LabOrder> labOrders = labDao.findUnbilledOrdersByPatientId(patientId);
        for (LabOrder o : labOrders) {
            BigDecimal fee = o.getLabFee() != null ? o.getLabFee() : BigDecimal.ZERO;
            totalLab = totalLab.add(fee);
            items.add(new BillItem("LAB_TEST",
                    "Lab Test - " + (o.getTestName() != null ? o.getTestName() : "Test") +
                            " [" + (o.getTestCategory() != null ? o.getTestCategory() : "") + "]",
                    fee, 1, fee));
        }

        draft.setConsultationCharges(totalConsultation);
        draft.setLabCharges(totalLab);
        draft.setRoomCharges(BigDecimal.ZERO);
        draft.setPharmacyCharges(BigDecimal.ZERO);
        draft.setOtherCharges(new BigDecimal("100.00")); // Standard Hospital Service Fee
        items.add(new BillItem("SERVICE", "Hospital Administrative & Nursing Care Fee", new BigDecimal("100.00"), 1, new BigDecimal("100.00")));

        BigDecimal subtotal = totalConsultation.add(totalLab).add(draft.getOtherCharges());
        draft.setSubtotal(subtotal);
        draft.setDiscountPercentage(BigDecimal.ZERO);
        draft.setDiscountAmount(BigDecimal.ZERO);

        // 5% standard GST/Service tax
        BigDecimal taxRate = new BigDecimal("5.00");
        BigDecimal taxAmount = subtotal.multiply(taxRate).divide(new BigDecimal("100.00"), 2, RoundingMode.HALF_UP);
        draft.setTaxPercentage(taxRate);
        draft.setTaxAmount(taxAmount);

        BigDecimal total = subtotal.add(taxAmount);
        draft.setTotalAmount(total);
        draft.setPaidAmount(BigDecimal.ZERO);
        draft.setBalanceAmount(total);
        draft.setItems(items);

        return draft;
    }

    @Override
    @Transactional
    public Bill generateBill(Bill bill) {
        if (bill.getBillNumber() == null || bill.getBillNumber().trim().isEmpty()) {
            bill.setBillNumber(billingDao.generateNextBillNumber());
        }

        // Recompute financial values safely
        BigDecimal consult = bill.getConsultationCharges() != null ? bill.getConsultationCharges() : BigDecimal.ZERO;
        BigDecimal lab = bill.getLabCharges() != null ? bill.getLabCharges() : BigDecimal.ZERO;
        BigDecimal room = bill.getRoomCharges() != null ? bill.getRoomCharges() : BigDecimal.ZERO;
        BigDecimal pharm = bill.getPharmacyCharges() != null ? bill.getPharmacyCharges() : BigDecimal.ZERO;
        BigDecimal other = bill.getOtherCharges() != null ? bill.getOtherCharges() : BigDecimal.ZERO;

        BigDecimal subtotal = consult.add(lab).add(room).add(pharm).add(other);
        bill.setSubtotal(subtotal);

        BigDecimal discPct = bill.getDiscountPercentage() != null ? bill.getDiscountPercentage() : BigDecimal.ZERO;
        BigDecimal discAmt = subtotal.multiply(discPct).divide(new BigDecimal("100.00"), 2, RoundingMode.HALF_UP);
        bill.setDiscountAmount(discAmt);

        BigDecimal taxable = subtotal.subtract(discAmt);
        BigDecimal taxPct = bill.getTaxPercentage() != null ? bill.getTaxPercentage() : BigDecimal.ZERO;
        BigDecimal taxAmt = taxable.multiply(taxPct).divide(new BigDecimal("100.00"), 2, RoundingMode.HALF_UP);
        bill.setTaxAmount(taxAmt);

        BigDecimal grandTotal = taxable.add(taxAmt);
        bill.setTotalAmount(grandTotal);

        BigDecimal paid = bill.getPaidAmount() != null ? bill.getPaidAmount() : BigDecimal.ZERO;
        bill.setPaidAmount(paid);

        BigDecimal balance = grandTotal.subtract(paid);
        if (balance.compareTo(BigDecimal.ZERO) < 0) {
            balance = BigDecimal.ZERO;
        }
        bill.setBalanceAmount(balance);

        if (paid.compareTo(BigDecimal.ZERO) <= 0) {
            bill.setPaymentStatus("UNPAID");
        } else if (paid.compareTo(grandTotal) >= 0) {
            bill.setPaymentStatus("PAID");
            bill.setBalanceAmount(BigDecimal.ZERO);
        } else {
            bill.setPaymentStatus("PARTIAL");
        }

        bill.setBillingDate(new Timestamp(System.currentTimeMillis()));

        // Save Bill
        Long billId = billingDao.saveBill(bill);
        bill.setId(billId);

        // Generate default item breakdown if list is empty
        if (bill.getItems() == null || bill.getItems().isEmpty()) {
            List<BillItem> items = new ArrayList<>();
            if (consult.compareTo(BigDecimal.ZERO) > 0) {
                items.add(new BillItem(billId, "CONSULTATION", "Doctor Consultation Charges", consult, 1, consult));
            }
            if (lab.compareTo(BigDecimal.ZERO) > 0) {
                items.add(new BillItem(billId, "LAB_TEST", "Laboratory Investigation Charges", lab, 1, lab));
            }
            if (room.compareTo(BigDecimal.ZERO) > 0) {
                items.add(new BillItem(billId, "ROOM", "Hospital Bed & Room Charges", room, 1, room));
            }
            if (pharm.compareTo(BigDecimal.ZERO) > 0) {
                items.add(new BillItem(billId, "PHARMACY", "Pharmacy and Medication Charges", pharm, 1, pharm));
            }
            if (other.compareTo(BigDecimal.ZERO) > 0) {
                items.add(new BillItem(billId, "SERVICE", "Administrative & Hospital Services", other, 1, other));
            }
            bill.setItems(items);
        } else {
            for (BillItem item : bill.getItems()) {
                item.setBillId(billId);
            }
        }

        if (!bill.getItems().isEmpty()) {
            billingDao.saveBillItems(bill.getItems());
        }

        // Mark consultations for this patient as BILLED
        List<Consultation> unbilledConsults = consultationDao.findUnbilledByPatientId(bill.getPatientId());
        for (Consultation c : unbilledConsults) {
            consultationDao.updateStatus(c.getId(), "BILLED");
        }

        // Mark lab orders for this patient as BILLED
        List<LabOrder> unbilledOrders = labDao.findUnbilledOrdersByPatientId(bill.getPatientId());
        for (LabOrder o : unbilledOrders) {
            labDao.updateOrderStatus(o.getId(), "BILLED", o.getResultSummary());
        }

        return bill;
    }

    @Override
    @Transactional
    public boolean processPayment(Long billId, BigDecimal paymentAmount, String paymentMode, String remarks) {
        Bill bill = billingDao.findBillById(billId)
                .orElseThrow(() -> new IllegalArgumentException("Bill not found with ID: " + billId));

        BigDecimal currentPaid = bill.getPaidAmount() != null ? bill.getPaidAmount() : BigDecimal.ZERO;
        BigDecimal newPaid = currentPaid.add(paymentAmount != null ? paymentAmount : BigDecimal.ZERO);

        BigDecimal total = bill.getTotalAmount();
        BigDecimal balance = total.subtract(newPaid);
        if (balance.compareTo(BigDecimal.ZERO) < 0) {
            balance = BigDecimal.ZERO;
        }

        String status = "PARTIAL";
        if (newPaid.compareTo(total) >= 0) {
            status = "PAID";
            balance = BigDecimal.ZERO;
        }

        String updatedRemarks = (bill.getRemarks() != null ? bill.getRemarks() + " | " : "") +
                (remarks != null ? remarks : "Payment of Rs." + paymentAmount + " received via " + paymentMode);

        return billingDao.updatePayment(billId, newPaid, balance, status, paymentMode, updatedRemarks) > 0;
    }

    @Override
    public Bill getBillById(Long id) {
        return billingDao.findBillById(id).orElse(null);
    }

    @Override
    public Bill getBillByNumber(String billNumber) {
        return billingDao.findBillByNumber(billNumber).orElse(null);
    }

    @Override
    public List<Bill> getAllBills() {
        return billingDao.findAllBills();
    }

    @Override
    public List<Bill> getBillsByPatientId(Long patientId) {
        return billingDao.findBillsByPatientId(patientId);
    }

    @Override
    public DashboardStats getDashboardStatistics() {
        DashboardStats stats = new DashboardStats();
        stats.setTotalPatients(patientDao.count());
        stats.setTotalDoctors(doctorDao.count());
        stats.setTotalConsultations(consultationDao.count());
        stats.setTotalLabOrders(labDao.countOrders());
        stats.setPendingLabOrders(labDao.countPendingOrders());
        stats.setTotalBills(billingDao.countBills());
        stats.setUnpaidBills(billingDao.countUnpaidBills());
        stats.setTotalRevenue(billingDao.sumTotalRevenue());
        stats.setPendingBalance(billingDao.sumPendingBalance());
        stats.setTotalAuditLogs(auditLogDao.count());
        stats.setPerformanceAlerts(performanceLogDao.countAlerts());
        return stats;
    }
}
