package com.hospital.service;

import com.hospital.dao.AuditLogDao;
import com.hospital.dao.PerformanceLogDao;
import com.hospital.model.AuditLog;
import com.hospital.model.PerformanceLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MonitoringServiceImpl implements MonitoringService {

    private final AuditLogDao auditLogDao;
    private final PerformanceLogDao performanceLogDao;

    @Autowired
    public MonitoringServiceImpl(AuditLogDao auditLogDao, PerformanceLogDao performanceLogDao) {
        this.auditLogDao = auditLogDao;
        this.performanceLogDao = performanceLogDao;
    }

    @Override
    public List<AuditLog> getRecentAuditLogs(int limit) {
        return auditLogDao.findRecent(limit);
    }

    @Override
    public List<PerformanceLog> getRecentPerformanceLogs(int limit) {
        return performanceLogDao.findRecent(limit);
    }

    @Override
    public void logAuditEvent(String action, String entityName, String entityId, String details, String performedBy) {
        AuditLog log = new AuditLog(action, entityName, entityId, details, performedBy);
        auditLogDao.save(log);
    }

    @Override
    public void recordExecutionMetric(String className, String methodName, long executionTimeMs, boolean thresholdExceeded) {
        PerformanceLog log = new PerformanceLog(className, methodName, executionTimeMs, thresholdExceeded);
        performanceLogDao.save(log);
    }
}
