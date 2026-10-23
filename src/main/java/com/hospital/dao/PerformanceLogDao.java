package com.hospital.dao;

import com.hospital.model.PerformanceLog;
import java.util.List;

public interface PerformanceLogDao {
    Long save(PerformanceLog log);
    List<PerformanceLog> findRecent(int limit);
    int countAlerts();
}
