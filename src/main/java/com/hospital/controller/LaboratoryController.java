package com.hospital.controller;

import com.hospital.model.Doctor;
import com.hospital.model.LabOrder;
import com.hospital.model.LabTestCatalog;
import com.hospital.model.Patient;
import com.hospital.service.ConsultationService;
import com.hospital.service.LaboratoryService;
import com.hospital.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/lab")
public class LaboratoryController {

    private final LaboratoryService laboratoryService;
    private final PatientService patientService;
    private final ConsultationService consultationService;

    @Autowired
    public LaboratoryController(LaboratoryService laboratoryService,
                                PatientService patientService,
                                ConsultationService consultationService) {
        this.laboratoryService = laboratoryService;
        this.patientService = patientService;
        this.consultationService = consultationService;
    }

    @GetMapping
    public String listLabActivities(Model model) {
        List<LabOrder> orders = laboratoryService.getAllOrders();
        List<LabTestCatalog> catalog = laboratoryService.getAllCatalogTests();

        model.addAttribute("orders", orders);
        model.addAttribute("catalog", catalog);
        return "lab-list";
    }

    @GetMapping("/order")
    public String showOrderForm(@RequestParam(value = "patientId", required = false) Long patientId, Model model) {
        LabOrder order = new LabOrder();
        if (patientId != null) {
            order.setPatientId(patientId);
        }

        List<Patient> patients = patientService.getAllPatients();
        List<LabTestCatalog> testCatalog = laboratoryService.getAllCatalogTests();
        List<Doctor> doctors = consultationService.getAllDoctors();

        model.addAttribute("order", order);
        model.addAttribute("patients", patients);
        model.addAttribute("testCatalog", testCatalog);
        model.addAttribute("doctors", doctors);
        return "lab-form";
    }

    @PostMapping("/order")
    public String saveOrder(@ModelAttribute("order") LabOrder order, RedirectAttributes redirectAttributes) {
        laboratoryService.orderLabTest(order);
        redirectAttributes.addFlashAttribute("successMessage", "Laboratory investigation ordered successfully.");
        return "redirect:/lab";
    }

    @PostMapping("/result/{id}")
    public String updateResult(@PathVariable("id") Long id,
                               @RequestParam("status") String status,
                               @RequestParam("resultSummary") String resultSummary,
                               RedirectAttributes redirectAttributes) {
        laboratoryService.updateLabResult(id, status, resultSummary);
        redirectAttributes.addFlashAttribute("successMessage", "Laboratory test results and report updated.");
        return "redirect:/lab";
    }
}
