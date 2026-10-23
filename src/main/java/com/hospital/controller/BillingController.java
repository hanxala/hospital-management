package com.hospital.controller;

import com.hospital.model.Bill;
import com.hospital.model.Patient;
import com.hospital.service.BillingService;
import com.hospital.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/billing")
public class BillingController {

    private final BillingService billingService;
    private final PatientService patientService;

    @Autowired
    public BillingController(BillingService billingService, PatientService patientService) {
        this.billingService = billingService;
        this.patientService = patientService;
    }

    @GetMapping
    public String listBills(Model model) {
        List<Bill> bills = billingService.getAllBills();
        model.addAttribute("bills", bills);
        model.addAttribute("stats", billingService.getDashboardStatistics());
        return "billing-list";
    }

    @GetMapping("/new")
    public String createBill(@RequestParam(value = "patientId", required = false) Long patientId, Model model) {
        if (patientId == null) {
            List<Patient> patients = patientService.getAllPatients();
            model.addAttribute("patients", patients);
            return "billing-select-patient";
        }

        Bill draftBill = billingService.prepareDraftBill(patientId);
        model.addAttribute("bill", draftBill);
        return "billing-form";
    }

    @PostMapping("/generate")
    public String generateBill(@ModelAttribute("bill") Bill bill, RedirectAttributes redirectAttributes) {
        Bill createdBill = billingService.generateBill(bill);
        redirectAttributes.addFlashAttribute("successMessage", "Hospital Invoice generated successfully: " + createdBill.getBillNumber());
        return "redirect:/billing/invoice/" + createdBill.getBillNumber();
    }

    @GetMapping("/invoice/{billNumber}")
    public String viewInvoice(@PathVariable("billNumber") String billNumber, Model model) {
        Bill bill = billingService.getBillByNumber(billNumber);
        if (bill == null) {
            return "redirect:/billing";
        }
        model.addAttribute("bill", bill);
        return "billing-invoice";
    }

    @PostMapping("/pay")
    public String processPayment(@RequestParam("billId") Long billId,
                                 @RequestParam("paymentAmount") BigDecimal paymentAmount,
                                 @RequestParam("paymentMode") String paymentMode,
                                 @RequestParam(value = "remarks", required = false) String remarks,
                                 RedirectAttributes redirectAttributes) {
        Bill bill = billingService.getBillById(billId);
        if (bill != null) {
            billingService.processPayment(billId, paymentAmount, paymentMode, remarks);
            redirectAttributes.addFlashAttribute("successMessage", "Payment of Rs. " + paymentAmount + " recorded successfully!");
            return "redirect:/billing/invoice/" + bill.getBillNumber();
        }
        return "redirect:/billing";
    }
}
