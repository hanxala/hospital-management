package com.hospital.dao;

import com.hospital.model.LabOrder;
import com.hospital.model.LabTestCatalog;
import java.util.List;
import java.util.Optional;

public interface LabDao {
    List<LabTestCatalog> findAllCatalog();
    Optional<LabTestCatalog> findCatalogById(Long id);

    Long saveOrder(LabOrder order);
    int updateOrderStatus(Long orderId, String status, String resultSummary);
    Optional<LabOrder> findOrderById(Long id);
    List<LabOrder> findAllOrders();
    List<LabOrder> findOrdersByPatientId(Long patientId);
    List<LabOrder> findUnbilledOrdersByPatientId(Long patientId);
    int countOrders();
    int countPendingOrders();
}
