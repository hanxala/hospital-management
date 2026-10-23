package com.hospital.service;

import com.hospital.model.AuditLog;
import com.hospital.model.PerformanceLog;
import java.util.List;

public interface MonitoringService {
    List<AuditLog> getRecentAuditLogs(int limit);
    List<PerformanceLog> getRecentPerformanceLogs(int limit);
    void logAuditEvent(String action, String entityName, String entityId, String details, String performedBy);
    void recordExecutionMetric(String className, String methodName, long executionTimeMs, boolean thresholdExceeded);
}
