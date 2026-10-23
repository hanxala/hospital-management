package com.hospital.service;

import com.hospital.dao.LabDao;
import com.hospital.model.LabOrder;
import com.hospital.model.LabTestCatalog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class LaboratoryServiceImpl implements LaboratoryService {

    private final LabDao labDao;

    @Autowired
    public LaboratoryServiceImpl(LabDao labDao) {
        this.labDao = labDao;
    }

    @Override
    public List<LabTestCatalog> getAllCatalogTests() {
        return labDao.findAllCatalog();
    }

    @Override
    public LabTestCatalog getCatalogTestById(Long id) {
        return labDao.findCatalogById(id).orElse(null);
    }

    @Override
    @Transactional
    public Long orderLabTest(LabOrder order) {
        if (order.getLabFee() == null && order.getTestId() != null) {
            labDao.findCatalogById(order.getTestId()).ifPresent(test ->
                order.setLabFee(test.getStandardFee())
            );
        }
        return labDao.saveOrder(order);
    }

    @Override
    @Transactional
    public boolean updateLabResult(Long orderId, String status, String resultSummary) {
        return labDao.updateOrderStatus(orderId, status, resultSummary) > 0;
    }

    @Override
    public LabOrder getOrderById(Long id) {
        return labDao.findOrderById(id).orElse(null);
    }

    @Override
    public List<LabOrder> getAllOrders() {
        return labDao.findAllOrders();
    }

    @Override
    public List<LabOrder> getOrdersByPatientId(Long patientId) {
        return labDao.findOrdersByPatientId(patientId);
    }

    @Override
    public List<LabOrder> getUnbilledOrdersByPatientId(Long patientId) {
        return labDao.findUnbilledOrdersByPatientId(patientId);
    }
}
