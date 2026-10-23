package com.hospital.model;

import java.math.BigDecimal;

public class DashboardStats {
    private int totalPatients;
    private int totalDoctors;
    private int totalConsultations;
    private int totalLabOrders;
    private int pendingLabOrders;
    private int totalBills;
    private int unpaidBills;
    private BigDecimal totalRevenue;
    private BigDecimal pendingBalance;
    private int totalAuditLogs;
    private int performanceAlerts;

    public DashboardStats() {
        this.totalRevenue = BigDecimal.ZERO;
        this.pendingBalance = BigDecimal.ZERO;
    }

    public int getTotalPatients() {
        return totalPatients;
    }

    public void setTotalPatients(int totalPatients) {
        this.totalPatients = totalPatients;
    }

    public int getTotalDoctors() {
        return totalDoctors;
    }

    public void setTotalDoctors(int totalDoctors) {
        this.totalDoctors = totalDoctors;
    }

    public int getTotalConsultations() {
        return totalConsultations;
    }

    public void setTotalConsultations(int totalConsultations) {
        this.totalConsultations = totalConsultations;
    }

    public int getTotalLabOrders() {
        return totalLabOrders;
    }

    public void setTotalLabOrders(int totalLabOrders) {
        this.totalLabOrders = totalLabOrders;
    }

    public int getPendingLabOrders() {
        return pendingLabOrders;
    }

    public void setPendingLabOrders(int pendingLabOrders) {
        this.pendingLabOrders = pendingLabOrders;
    }

    public int getTotalBills() {
        return totalBills;
    }

    public void setTotalBills(int totalBills) {
        this.totalBills = totalBills;
    }

    public int getUnpaidBills() {
        return unpaidBills;
    }

    public void setUnpaidBills(int unpaidBills) {
        this.unpaidBills = unpaidBills;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public BigDecimal getPendingBalance() {
        return pendingBalance;
    }

    public void setPendingBalance(BigDecimal pendingBalance) {
        this.pendingBalance = pendingBalance;
    }

    public int getTotalAuditLogs() {
        return totalAuditLogs;
    }

    public void setTotalAuditLogs(int totalAuditLogs) {
        this.totalAuditLogs = totalAuditLogs;
    }

    public int getPerformanceAlerts() {
        return performanceAlerts;
    }

    public void setPerformanceAlerts(int performanceAlerts) {
        this.performanceAlerts = performanceAlerts;
    }
}
