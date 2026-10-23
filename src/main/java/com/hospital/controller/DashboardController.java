package com.hospital.controller;

import com.hospital.model.DashboardStats;
import com.hospital.service.BillingService;
import com.hospital.service.MonitoringService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

    private final BillingService billingService;
    private final MonitoringService monitoringService;

    @Autowired
    public DashboardController(BillingService billingService, MonitoringService monitoringService) {
        this.billingService = billingService;
        this.monitoringService = monitoringService;
    }

    @GetMapping({"/", "/dashboard"})
    public String viewDashboard(Model model) {
        DashboardStats stats = billingService.getDashboardStatistics();
        model.addAttribute("stats", stats);
        model.addAttribute("recentBills", billingService.getAllBills());
        model.addAttribute("recentAuditLogs", monitoringService.getRecentAuditLogs(6));
        model.addAttribute("recentPerformanceLogs", monitoringService.getRecentPerformanceLogs(6));
        return "dashboard";
    }
}
