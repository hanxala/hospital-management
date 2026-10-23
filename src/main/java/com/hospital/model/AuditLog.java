package com.hospital.model;

import java.sql.Timestamp;

public class AuditLog {
    private Long id;
    private String action;
    private String entityName;
    private String entityId;
    private String details;
    private String performedBy;
    private Timestamp timestamp;

    public AuditLog() {
    }

    public AuditLog(Long id, String action, String entityName, String entityId, String details, String performedBy,
                    Timestamp timestamp) {
        this.id = id;
        this.action = action;
        this.entityName = entityName;
        this.entityId = entityId;
        this.details = details;
        this.performedBy = performedBy;
        this.timestamp = timestamp;
    }

    public AuditLog(String action, String entityName, String entityId, String details, String performedBy) {
        this.action = action;
        this.entityName = entityName;
        this.entityId = entityId;
        this.details = details;
        this.performedBy = performedBy;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getEntityName() {
        return entityName;
    }

    public void setEntityName(String entityName) {
        this.entityName = entityName;
    }

    public String getEntityId() {
        return entityId;
    }

    public void setEntityId(String entityId) {
        this.entityId = entityId;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public String getPerformedBy() {
        return performedBy;
    }

    public void setPerformedBy(String performedBy) {
        this.performedBy = performedBy;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }
}
