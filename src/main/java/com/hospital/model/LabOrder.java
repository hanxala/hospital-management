package com.hospital.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class LabOrder {
    private Long id;
    private Long patientId;
    private Long testId;
    private Long doctorId;
    private Timestamp orderDate;
    private BigDecimal labFee;
    private String status;
    private String resultSummary;
    private Timestamp reportedDate;

    // Joined fields for display
    private String patientName;
    private String patientUhid;
    private String testName;
    private String testCode;
    private String testCategory;
    private String doctorName;

    public LabOrder() {
    }

    public LabOrder(Long id, Long patientId, Long testId, Long doctorId, Timestamp orderDate, BigDecimal labFee,
                    String status, String resultSummary, Timestamp reportedDate) {
        this.id = id;
        this.patientId = patientId;
        this.testId = testId;
        this.doctorId = doctorId;
        this.orderDate = orderDate;
        this.labFee = labFee;
        this.status = status;
        this.resultSummary = resultSummary;
        this.reportedDate = reportedDate;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getPatientId() {
        return patientId;
    }

    public void setPatientId(Long patientId) {
        this.patientId = patientId;
    }

    public Long getTestId() {
        return testId;
    }

    public void setTestId(Long testId) {
        this.testId = testId;
    }

    public Long getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(Long doctorId) {
        this.doctorId = doctorId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getLabFee() {
        return labFee;
    }

    public void setLabFee(BigDecimal labFee) {
        this.labFee = labFee;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getResultSummary() {
        return resultSummary;
    }

    public void setResultSummary(String resultSummary) {
        this.resultSummary = resultSummary;
    }

    public Timestamp getReportedDate() {
        return reportedDate;
    }

    public void setReportedDate(Timestamp reportedDate) {
        this.reportedDate = reportedDate;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getPatientUhid() {
        return patientUhid;
    }

    public void setPatientUhid(String patientUhid) {
        this.patientUhid = patientUhid;
    }

    public String getTestName() {
        return testName;
    }

    public void setTestName(String testName) {
        this.testName = testName;
    }

    public String getTestCode() {
        return testCode;
    }

    public void setTestCode(String testCode) {
        this.testCode = testCode;
    }

    public String getTestCategory() {
        return testCategory;
    }

    public void setTestCategory(String testCategory) {
        this.testCategory = testCategory;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
}
