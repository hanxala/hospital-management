package com.hospital.service;

import com.hospital.model.LabOrder;
import com.hospital.model.LabTestCatalog;
import java.util.List;

public interface LaboratoryService {
    List<LabTestCatalog> getAllCatalogTests();
    LabTestCatalog getCatalogTestById(Long id);
    Long orderLabTest(LabOrder order);
    boolean updateLabResult(Long orderId, String status, String resultSummary);
    LabOrder getOrderById(Long id);
    List<LabOrder> getAllOrders();
    List<LabOrder> getOrdersByPatientId(Long patientId);
    List<LabOrder> getUnbilledOrdersByPatientId(Long patientId);
}
