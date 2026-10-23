package com.hospital.model;

import java.sql.Timestamp;

public class PerformanceLog {
    private Long id;
    private String className;
    private String methodName;
    private Long executionTimeMs;
    private Boolean thresholdExceeded;
    private Timestamp timestamp;

    public PerformanceLog() {
    }

    public PerformanceLog(Long id, String className, String methodName, Long executionTimeMs,
                          Boolean thresholdExceeded, Timestamp timestamp) {
        this.id = id;
        this.className = className;
        this.methodName = methodName;
        this.executionTimeMs = executionTimeMs;
        this.thresholdExceeded = thresholdExceeded;
        this.timestamp = timestamp;
    }

    public PerformanceLog(String className, String methodName, Long executionTimeMs, Boolean thresholdExceeded) {
        this.className = className;
        this.methodName = methodName;
        this.executionTimeMs = executionTimeMs;
        this.thresholdExceeded = thresholdExceeded;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getMethodName() {
        return methodName;
    }

    public void setMethodName(String methodName) {
        this.methodName = methodName;
    }

    public Long getExecutionTimeMs() {
        return executionTimeMs;
    }

    public void setExecutionTimeMs(Long executionTimeMs) {
        this.executionTimeMs = executionTimeMs;
    }

    public Boolean getThresholdExceeded() {
        return thresholdExceeded;
    }

    public void setThresholdExceeded(Boolean thresholdExceeded) {
        this.thresholdExceeded = thresholdExceeded;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }
}
