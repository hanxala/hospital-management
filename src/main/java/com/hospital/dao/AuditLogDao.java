package com.hospital.dao;

import com.hospital.model.AuditLog;
import java.util.List;

public interface AuditLogDao {
    Long save(AuditLog log);
    List<AuditLog> findRecent(int limit);
    int count();
}
