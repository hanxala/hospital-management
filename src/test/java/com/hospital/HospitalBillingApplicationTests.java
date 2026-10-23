package com.hospital;

import com.hospital.dao.AuditLogDao;
import com.hospital.dao.PerformanceLogDao;
import com.hospital.model.Bill;
import com.hospital.model.Patient;
import com.hospital.service.BillingService;
import com.hospital.service.PatientService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class HospitalBillingApplicationTests {

    @Autowired
    private PatientService patientService;

    @Autowired
    private BillingService billingService;

    @Autowired
    private AuditLogDao auditLogDao;

    @Autowired
    private PerformanceLogDao performanceLogDao;

    @Test
    void contextLoads() {
        assertNotNull(patientService, "PatientService should be loaded in Spring context");
        assertNotNull(billingService, "BillingService should be loaded in Spring context");
    }

    @Test
    void testPatientRegistrationAndBillingIntegration() {
        // 1. Register a test patient
        Patient patient = new Patient();
        patient.setFirstName("Vikram");
        patient.setLastName("Malhotra");
        patient.setAge(39);
        patient.setGender("Male");
        patient.setPhone("+91 9988776655");
        patient.setEmail("vikram.m@test.com");
        patient.setBloodGroup("O+");
        patient.setAddress("Marine Drive, Mumbai");

        Long patientId = patientService.registerPatient(patient);
        assertNotNull(patientId, "Registered patient should receive generated primary key ID");
        assertNotNull(patient.getPatientUhid(), "Patient should have an auto-generated UHID");

        // 2. Prepare draft bill
        Bill draft = billingService.prepareDraftBill(patientId);
        assertNotNull(draft, "Draft bill should be created");
        assertEquals(patientId, draft.getPatientId());

        // Set financial fields
        draft.setConsultationCharges(new BigDecimal("700.00"));
        draft.setLabCharges(new BigDecimal("350.00"));
        draft.setPaidAmount(new BigDecimal("500.00"));
        draft.setPaymentMode("UPI");

        int initialAuditCount = auditLogDao.count();

        // 3. Generate bill (This triggers AOP BillingAuditAspect)
        Bill savedBill = billingService.generateBill(draft);
        assertNotNull(savedBill.getId(), "Generated bill should have ID");
        assertEquals("PARTIAL", savedBill.getPaymentStatus());

        // 4. Verify AOP Billing Audit Aspect intercepted and persisted audit log
        int newAuditCount = auditLogDao.count();
        assertTrue(newAuditCount > initialAuditCount, "Spring AOP BillingAuditAspect should persist an audit log entry");

        // 5. Verify AOP Service Performance Monitoring Aspect captured execution
        int perfLogsCount = performanceLogDao.findRecent(10).size();
        assertTrue(perfLogsCount > 0, "Spring AOP ServicePerformanceAspect should record service method execution times");
    }
}
