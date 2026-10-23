package com.hospital.controller;

import com.hospital.model.AuditLog;
import com.hospital.model.PerformanceLog;
import com.hospital.service.MonitoringService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/aop-monitor")
public class AopMonitoringController {

    private final MonitoringService monitoringService;

    @Value("${hospital.performance.threshold-ms:20}")
    private long thresholdMs;

    @Autowired
    public AopMonitoringController(MonitoringService monitoringService) {
        this.monitoringService = monitoringService;
    }

    @GetMapping
    public String viewAopMonitor(Model model) {
        List<AuditLog> auditLogs = monitoringService.getRecentAuditLogs(50);
        List<PerformanceLog> performanceLogs = monitoringService.getRecentPerformanceLogs(50);

        model.addAttribute("auditLogs", auditLogs);
        model.addAttribute("performanceLogs", performanceLogs);
        model.addAttribute("thresholdMs", thresholdMs);
        return "aop-monitor";
    }
}
